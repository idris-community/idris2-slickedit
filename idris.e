/// SlickEdit module for Idris programming
#include "slick.sh"

static _str _quote(_str s) {
  // TODO: escape s
  return '"' :+ s :+ '"';
}

static int _run(_str cmd) {
  if (
    (auto h =
       _PipeProcess(cmd, auto hin, auto _, auto __, "")) < 0) {
    _message_box(
      "Could not run:\n" :+ cmd :+ "\nerror: " :+ get_message(h),
      "Error", MB_OK | MB_ICONSTOP);
    return 1;
  } else if (_PipeRead(hin, auto s, 0, 0)) {
    _PipeCloseProcess(h);
    _message_box(s);
    return 1;
  } else if (length(s) > 0)
    _message_box(s, cmd, MB_OK | MB_ICONNONE);
  _PipeCloseProcess(h);
  return 0;
}

static int _idris(...) {
  _str cmd[];
  for (i=0; i < arg() ; ++i)
    cmd[i] = arg(i+1);

  return _run("idris --client " :+ _quote(join(cmd, " ")));
}

static _idris_cmd_line_word(_str cmd) {
  if (save())
    message("Could not save file");
  else if (_idris(":l", p_buf_name))
    message("Could not load file in Idris");
  else if (_idris(cmd, p_line, _cur_word()))
    message("Command failed: " :+ cmd);
  else
    revert("1");
}

static _idris_cmd_word(_str cmd) {
  if (save())
    message("Could not save file");
  else if (_idris(":l", p_buf_name))
    message("Could not load file in Idris");
  else if (_idris(cmd, _cur_word()))
    message("Command failed: " :+ cmd);
  else
    revert("1");
}

static _str _cur_word() {
  return cur_word(auto _);
}

_command IdrisReload() {
  if (save())
    message("Could not save file");
  else if (_idris(":l", p_buf_name))
    message("Could not load file in Idris");
  else
    message("This file type-checks correctly");
}

_command IdrisDoc() {
  if (_idris(":doc", _cur_word()))
    message("Could not show documentation for: " :+ _cur_word());
}
_command IdrisTypeCheck() { _idris_cmd_word(":t"); }
_command IdrisTotal() { _idris_cmd_word(":total"); }

_command IdrisAddDefinition() { _idris_cmd_line_word(":ac!"); }
_command IdrisAddMissingCases() { _idris_cmd_line_word(":am!"); }
_command IdrisCaseSplit() { _idris_cmd_line_word(":cs!"); }
_command IdrisMakeCase() { _idris_cmd_line_word(":mc!"); }
_command IdrisMakeLemma() { _idris_cmd_line_word(":ml!"); }
_command IdrisSearchExpression() { _idris_cmd_line_word(":ps!"); }
