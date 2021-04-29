# idris-slickedit
SlickEdit support for Idris2, providing standard editing features
- Auto Completion
- Go-To-Definition
- Syntax Coloring
and Idris2 interactive editing features:
- Add Definition
- Add Missing Cases
- Case Split
- Generate Definition
- Get Documentation
- Hole Inspection (aka Get Type)
- Make Case
- Make Lemma
- Make With
- Proof Search
- Totality Check

## Installation

Run `makeconfigzip` it will create a file `Idris.zip` and print out the SlickEdit command you need to run in order to import the plug-in.
Once imported you can define your preferred key bindings to the following macros:
- `IdrisReload` (i.e. `:r`)
- `IdrisDoc` (i.e. `:doc`)
- `IdrisTypeCheck` (i.e. `:t`)
- `IdrisTotal` (i.e. `:total`)
- `IdrisAddDefinition` (i.e. `:ac!`)
- `IdrisAddMissingCases` (i.e. `:am!`)
- `IdrisCaseSplit` (i.e. `:cs!`)
- `IdrisGenDefinition` (i.e. `:gd!`)
- `IdrisMakeCase` (i.e. `:mc!`)
- `IdrisMakeLemma` (i.e. `:ml!`)
- `IdrisMakeWith` (i.e. `:mw!`)
- `IdrisSearchExpression` (i.e. `:ps!`)
