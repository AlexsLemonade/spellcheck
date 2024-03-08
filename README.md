# spellcheck

This repository contains a GitHub action to run the [R `spelling` package](https://cran.r-project.org/web/packages/spelling/index.html).
The role of this action is to facilitate spell checking actions across `AlexsLemonade` repositories.

Currently the action will only spell check text in Rmd and md files

## Usage

To use this action, create a `.github/workflows/spellcheck.yml` file in your repository with the following contents (modified to fit your exact needs):

```yaml
name: Check Spelling
on:
  pull_request:
    branches:
     - main

jobs:
  spell-check:
    runs-on: ubuntu-latest
    name: Spell check files
    steps:

      - name: Checkout
        uses: actions/checkout@v4

      - name: Spell check action
        uses: alexslemonade/spellcheck
        id: spell
        with:
          dictionary: components/dictionary.txt

      - name: Upload spell check errors
        uses: actions/upload-artifact@v4
        with:
          name: spell_check_errors
          path: spell_check_errors.tsv

      - name: Fail if there are spelling errors
        if: steps.spell.outputs.error_count > 0
        run: |
          echo "There were ${{ steps.spell.outputs.error_count }} errors"
          exit 1
```

Note that the `dictionary` input to the spell check step is optional and defaults to `components/dictionary.txt`.
If you want to use a different dictionary, you can specify the path to the dictionary file in your repository.

You can also specify specific files to spell check using the `files` input to the `alexslemonade/spellcheck` step.
Globs should work as expected.
