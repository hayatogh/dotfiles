from prompt_toolkit.application import get_app
from prompt_toolkit.document import Document
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.filters import (
    Condition,
    emacs_insert_mode,
    has_focus,
    has_selection,
    vi_insert_mode,
)
from ptpython.utils import document_is_multiline_python

__all__ = ['configure']


def configure(repl):
    repl.complete_while_typing = False
    repl.enable_history_search = True
    repl.enable_mouse_support = True
    repl.confirm_exit = False

    repl.show_docstring = True
    repl.show_line_numbers = True
    repl.highlight_matching_parenthesis = True

    repl.use_code_colorscheme('native')

    repl.enable_open_in_editor = True
    repl.enable_system_bindings = True

    sidebar_visible = Condition(lambda: repl.show_sidebar)
    is_multiline = Condition(
        lambda: document_is_multiline_python(repl.default_buffer.document)
    )

    # Complement missing C-d with some input
    @repl.add_key_binding(
        'c-d',
        filter=~sidebar_visible
        & has_focus(DEFAULT_BUFFER)
        & Condition(lambda: get_app().current_buffer.text),
    )
    def _(event):
        b = event.current_buffer
        if b.validate():
            text = b.text.rstrip()
            b.document = Document(text=text, cursor_position=len(text))
            b.validate_and_handle()

    # Override Enter in the middle of single line input
    @repl.add_key_binding(
        'enter',
        filter=~sidebar_visible
        & ~has_selection
        & (vi_insert_mode | emacs_insert_mode)
        & has_focus(DEFAULT_BUFFER)
        & ~is_multiline
        & Condition(lambda: get_app().current_buffer.document.current_char),
    )
    def _(event):
        event.current_buffer.insert_text('\n')
