# Swagger Generator

## Description

How this works?

This script helps automate your documentation process. To use it, create a Swagger JSON file following the OpenAPI pattern and place it in the `JSON` folder. Then, run `make.sh`, which will generate HTML documentation and create a homepage to easily access all generated files.

You can integrate this script with GitHub Actions and GitHub Pages to automate deployment. For example, set it up to run on the `example` branch.

## How to use?

- Place your documentation files in the JSON folder.
- Run the make.sh script:

```sh
./make.sh
```

#### Use with Github Actions

- Setup Actions
- Create a yaml file
- Create a Github Token

```yaml
name: swagger-generator
on: [push]
jobs:
  redocly:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Install Redocly CLI
        run: npm install -g @redocly/cli

      - name: chmod to swagger.sh
        run: chmod +x swagger.sh

      - name: Build docs
        run: ./make.sh

      - name: Commit changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "github-actions"
          git add --all
          git commit -m "Generate swagger documentation"
      - name: Push changes
        uses: ad-m/github-push-action@master
        with:
          GH_TOKEN: ${{ secrets.GH_TOKEN }}
          branch: main
```

## Authors

- [@jonasssneto](https://www.github.com/jonasssneto)
