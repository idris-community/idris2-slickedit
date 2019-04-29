/// SlickEdit module for Idris programming
#include "slick.sh"
#include "tagsdb.sh"

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

int idris_proc_search(_str &proc_name, bool find_first)
{
  int status=0;
  if (find_first) {
    if (proc_name:=='')
      proc_name = _clex_identifier_re();
    _str cases[];
    // if first is upper it might be data-constructor, hence with leading spaces
    cases[0] = '^\c{'proc_name'}[ \t]*\:';
    cases[1] = '^record[ \t]+\c{'proc_name'}\b';
    cases[2] = '^[ \t]+constructor[ \t]+\c{'proc_name'}';
    cases[3] = '^data[ \t]+\c{'proc_name'}[ \t]*\:';
    status = search(join(cases, '|'), '@rh');
  } else
    status = repeat_search();
  if (status)
    return status;

  VS_TAG_BROWSE_INFO cm;
  if (length(get_match_text(0)))
    tag_init_tag_browse_info(cm, get_match_text(0), "", SE_TAG_TYPE_PROTO);
  else if (length(get_match_text(1)))
    tag_init_tag_browse_info(cm, get_match_text(1), "", SE_TAG_TYPE_STRUCT);
  else if (length(get_match_text(2)))
    tag_init_tag_browse_info(cm, get_match_text(2), "", SE_TAG_TYPE_CONSTRUCTORPROTO);
  else if (length(get_match_text(3)))
    tag_init_tag_browse_info(cm, get_match_text(3), "", SE_TAG_TYPE_TYPEDEF);
  else
    return 1;
  proc_name = tag_compose_tag_browse_info(cm);
  return 0;
}
