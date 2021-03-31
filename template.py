import re
import os

class TemplateSyntaxError(ValueError):
    pass

class Template(object):
    def __init__(self, text=None, filename=None, *contexts):
        self.context = {}
        for context in contexts:
            self.context.update(context)

        self.op_stack = []
        self.tag_stack = []
        self.all_vars = []
        self.tag = 0
        self.buff = []
        self.code = CodeBuilder()
        self.code.add_line("def render_function(context, do_dots):")
        self.code.indent()
        self.vars_code = self.code.add_section()
        self.code.add_line("result = []")
        self.code.add_line("append_result = result.append")
        self.code.add_line("extend_result = result.extend")
        if text is not None:
            self.text = text
            self._compile_text(self.text)
        elif filename is not None:
            if os.path.exists(filename):
                with open(filename, 'r') as fr:
                    self.text = fr.read()
                self._compile_text(self.text)
            else:
                print("Error: Invaild filename")


    def _compile_text(self, text):
        tokens = re.split(r"(?s)(<%|%>)", text)
        print(tokens)

        for token in tokens:
            print(self.tag_stack)
            if token == '<%':
                if len(self.tag_stack) == 0:
                    self.flush_output()
                self.tag_stack.append('<%')
                self.tag = 1
                continue
            elif token == '%>':
                if len(self.tag_stack):
                    tag = self.tag_stack.pop()
                    if tag == 'var':
                        pass
                    elif tag == 'if' or tag == 'while' or tag == 'for':
                        self.flush_output()
                        self.code.indent()
                    elif tag == 'elif' or tag == 'else':
                        self.code.dedent()
                        self.flush_output()
                        self.code.indent()
                    elif tag == 'end':
                        self.code.dedent()
                    if len(self.tag_stack):
                        self.tag_stack.pop()
                    else:
                        self._syntax_error('Error: unmatched tag', '%>')
                else:
                    self._syntax_error('Error: unmatched tag', '%>')
                self.tag = 0
            else:
                match0 = re.match('\$(\S+)', token)
                if match0 and self.tag:
                    var = match0.group(1)
                    expr = self._expr_code(var)
                    if expr not in self.all_vars:
                        self.all_vars.append(expr)
                    if (len(self.tag_stack)) == 1:
                        self.buff.append('str(%s)' % expr)
                    else:
                        self.buff.append('%s' % expr)
                    self.tag_stack.append('var')
                    self.tag = 0
                    continue
                match1 = re.match('\s*((if|while|for|else|elif).*)', token)
                if match1 and self.tag:
                    op = match1.group(2)
                    self.tag_stack.append(op)
                    if (op != 'else' and op != 'elif'):
                        self.op_stack.append(op)
                    self.buff.append(match1.group(1))
                    self.tag = 0
                    continue
                match2 = re.match('\s*end(\S+)', token)
                if match2 and self.tag:
                    self.tag_stack.append('end')
                    op = match2.group(1)
                    if op != self.op_stack.pop():
                        self._syntax_error('Error: unmatched ops', op)
                    continue
                if len(self.tag_stack) == 0:
                    self.buff.append(repr(token))
                else:
                    self.buff.append(token)
                self.tag = 0
        if self.op_stack:
            self._syntax_error("unmatched action tag", self.op_stack[-1])
        if self.tag_stack:
            self._syntax_error("unmatched tag", self.tag_stack[-1])
        self.flush_output()

        for var_name in self.all_vars:
            self.vars_code.add_line("%s = context.get('%s', '')" % (var_name, var_name))

        self.code.add_line("return ''.join(result)")
        self.code.dedent()
        self._render_function = self.code.get_globals()['render_function']

    def render(self, context=None):
        render_context = dict(self.context)
        if context:
            render_context.update(context)
        return self._render_function(render_context, self._do_dots)

    def flush_output(self):
        if len(self.buff) == 1:
            if len(self.tag_stack) == 0:
                self.code.add_line("append_result(%s)" % self.buff[0])
            else:
                self.code.add_line("%s" % self.buff[0])
        elif len(self.buff) > 1:
            if len(self.tag_stack) == 0:
                self.code.add_line("extend_result([%s])" % ", ".join(self.buff))
            else:
                self.code.add_line("%s" % " ".join(self.buff))
        del self.buff[:]



    def _variable(self, name):
        if not re.match(r"[_a-zA-Z][_a-zA-Z0-9]*$", name):
            self._syntax_error("Not a valid name", name)



    def _syntax_error(self, msg, thing):
        raise TemplateSyntaxError("%s: %r" % (msg, thing))

    def _expr_code(self, expr):
        if "." in expr:
            dots = expr.split(".")
            code = self._expr_code(dots[0])
            args = ", ".join(repr(d) for d in dots[1:])
            code = "do_dots(%s, %s)" % (code, args)
        else:
            self._variable(expr)
            code = "%s" % expr
        return code


    def _do_dots(self, value, *dots):
        for dot in dots:
            try:
                value = getattr(value, dot)
            except AttributeError:
                value = value[dot]
            if callable(value):
                value = value()
        return value



class CodeBuilder(object):

    def __init__(self, indent=0):
        self.code = []
        self.indent_level = indent

    def __str__(self):
        return "".join(str(c) for c in self.code)

    def add_line(self, line):
        self.code.extend([" " * self.indent_level, line, "\n"])

    def add_section(self):
        section = CodeBuilder(self.indent_level)
        self.code.append(section)
        return section

    INDENT_STEP = 4      # PEP8 says so!

    def indent(self):
        self.indent_level += self.INDENT_STEP

    def dedent(self):
        self.indent_level -= self.INDENT_STEP

    def get_globals(self):
        print(self.indent_level)
        assert self.indent_level == 0
        python_source = str(self)
        print('###01', python_source)
        global_namespace = {}
        exec(python_source, global_namespace)
        print("###11", global_namespace)
        return global_namespace
