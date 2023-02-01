Convert YAML files to markdown files

Usage:
  yaml2markdown [INPUT [OUTPUT]] [options]

Options:
  --using=STYLE   Style to use to render YAML objects.
                  Available values:
                  • [default: lists] — Use lists only (- **key**: value)
                  • tables           — Use GFM-style tables
                  • definitions      — Use MarkdownExtra-style definition lists

Arguments:
  INPUT            Specify file to use as input. Defaults to stdin.
  OUTPUT           Specify file to write the result to. Defaults to stdout.
