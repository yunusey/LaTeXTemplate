<h1 align="center"> LaTeX Template ✨ </h1>
<div align="center" border-radius="20px">
    <img src="./assets/latex-template-logo.png" width="200" height="200" />
</div>

*A clean and convenient LaTeX template powered by GitHub Actions for automated builds and Nix for dependency management.*

## Showcase 📸
You can see the compiled versions of the PDFs in the [artifacts](https://github.com/yunusey/latextemplate/blob/artifacts) branch:

| [Light Version](https://github.com/yunusey/latextemplate/blob/artifacts/Example/Example%20Light%20Version.pdf) | [Dark Version](https://github.com/yunusey/latextemplate/blob/artifacts/Example/Example%20Dark%20Version.pdf) |
| :------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------:|
| ![](./assets/Example%20Light%20Version%20Preview.png)                                                           | ![](./assets/Example%20Dark%20Version%20Preview.png)                                                         |


## Usage 📝

You can simply fork this repository and start writing. If you're a student like me and write your assignments in $\LaTeX$, you can create a folder in the project root (e.g., `./MyClass`), copy the template:

```bash
cp ./Template/template.tex ./MyClass/MyAssignment.tex
```

Then start writing! Once you commit and push your changes, GitHub Actions will automatically build your project. When the build finishes, you’ll find the generated PDFs either as downloadable artifacts or directly in the `artifacts` branch.

## Why Automated Builds? ⚙️

I often revisit my assignments or notes from my phone or another device. With this setup, every change triggers a GitHub Actions workflow that compiles my LaTeX files and pushes the results to the `artifacts` branch. This means I always have an up-to-date PDF available---anywhere, anytime.

## Why Nix? ❄️

As a NixOS user, I rely heavily on the Nix package manager, and it handles LaTeX dependencies beautifully. It also gives me full control over which packages my project uses, making debugging or extending my setup much easier.

## Themes 🎨

This template supports custom themes! Check out [`./Modules/theme.tex`](./Modules/theme.tex). You can define your own color scheme there.

In [`./Modules/preamble.tex`](./Modules/preamble.tex#L26-L36), LaTeX checks the `TBOX_THEME` environment variable or any theme you manually override in your document via:

```tex
\newcommand{\theme}{DarkTheme}
```

(See [`Example Dark Version.tex`](./Example/Example%20Dark%20Version.tex) for a usage example.)

**Build commands:**

```bash
nix build .#dark-theme-documents
nix build .#light-theme-documents
nix build .     # builds default (LightTheme)
```

> [!NOTE]
> **Changing the default theme:**
> Edit your [`flake.nix`](./flake.nix#L59) and update:
> `tbox_theme = "LightTheme";` to `tbox_theme = "DarkTheme";`

## Adding New Fonts 🔤

To include additional fonts, open your `flake.nix` and locate:

```nix
os_font_dir = with pkgs; "";
```

Suppose you want to use **Fira Code**. Find it on [NixOS Search](https://search.nixos.org). Its package is `fira-code`, and its fonts live under `$out/share/fonts/truetype`. Update the line to:

```nix
os_font_dir = with pkgs; "${fira-code}/share/fonts/truetype";
```

Then, in [`./Modules/fonts.tex`](./Modules/fonts.tex), declare it via `fontspec`:

```tex
\newfontfamily{\firacode}{FiraCode-VF}[
    Extension=.ttf,
    Ligatures=TeX,
    Scale=0.9
]
```

Now you can use it like:

```tex
\begin{myenvironment}
{
    \firacode
    This is my code with Fira Code!
}
\end{myenvironment}
```

Local fonts also work---just ensure they’re included in your `$OSFONTDIR` and loaded with `fontspec`.


## Adding New Packages 📦

If a package exists in TeXLive, simply find it on [NixOS Search](https://search.nixos.org) and add it to your flake:

```nix
tex = pkgs.texlive.combine {
  inherit (pkgs.texlive) scheme-medium latexmk ... my-awesome-package;
};
```


## What If a Package Isn’t in TeXLive? 🤔

Use the `./packages` folder (feel free to rename it, e.g., `./styles`) and drop any `.sty` files there.

If you have additional directories elsewhere, you can manually extend `$TEXINPUTS` (see [`flake.nix`](./flake.nix#L87)). By default:

```
TEXINPUTS=./packages
```

So anything in that folder will be picked up automatically.


## How I Use It 🚀

Check out an example note in [`./Example/Example.tex`](./Example/Example.tex) and its compiled version [here](https://github.com/yunusey/latextemplate/blob/artifacts/Example/Example.pdf).

My LaTeX workflow:

* IDE/PDE: [Neovim](https://neovim.io/)
* PDF Viewer: [Zathura](https://github.com/pwmt/zathura)
* LSP: [TexLab](https://github.com/latex-lsp/texlab)
* Main LaTeX Plugin: [VimTex](https://github.com/lervag/vimtex)
* Snippets: [LuaSnip](https://github.com/L3MON4D3/LuaSnip)

My dotfiles are private (they... need work :D), but these folks have excellent setups and guides:

* [ejmastnak](https://github.com/ejmastnak)
* [seniormars](https://github.com/seniormars/dotfiles)

In particular, [A guide to supercharged mathematical typesetting](https://ejmastnak.com/tutorials/vim-latex/intro/) is outstanding.

## Building Files Locally 🔄

Just run:

```bash
nix build
```

Your PDFs will appear in `./result/out` (which is `.gitignore`d).


## Development Environment 🛠️

Start a development shell with:

```bash
nix develop
```

If you use [direnv](https://github.com/direnv/direnv):

```bash
direnv allow
```

You’ll then automatically enter the devshell whenever you `cd` into this project.


## Quick Note on Formatting ✍️

The root folder includes an `indentconfig.yaml` for `latexindent`. Use it like:

```bash
latexindent --local ./indentconfig.yaml -wd ./Template/template.tex -c /tmp
```

If you use TexLab, you can configure it to use this file:

```lua
require('lspconfig').texlab.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "tex", "plaintex", "bib" },
    cmd = { "texlab", "-vvvv" },
    settings = {
        texlab = {
            latexindent = {
                ['local'] = vim.fn.getcwd() .. '/indentconfig.yaml',
            }
        }
    }
}
```

You can customize your `indentconfig.yaml` that fits your needs the best. Check out their [documentation](https://latexindentpl.readthedocs.io/en/latest/). It is very detailed.

## Features 🔥
- [x] Dependency management using Nix
- [x] Automated builds using GitHub Actions
    + [x] Automatically generated table of contents as your README in `artifacts` branch (see [artifacts](https://github.com/yunusey/latextemplate/blob/artifacts/README.md) branch as an example).
    + [x] Downloadable artifacts
- [ ] Caching for faster builds using [Cachix](https://cachix.org)

## References 🔗
- [GitHub Actions](https://github.com/features/actions)
    + [git-publish-subdir-action](https://github.com/s0/git-publish-subdir-action)
    + [install-nix-action](https://github.com/cachix/install-nix-action)
- [Nix](https://nixos.org)
- [Nixpkgs](https://github.com/NixOS/nixpkgs)
- [Cachix](https://cachix.org)
- [ejmastnak](https://github.com/ejmastnak)
- [seniormars](https://github.com/seniormars)
- [latexindent.pl](https://github.com/cmhughes/latexindent.pl)

## Reading List 📚
- [Exploring Nix Flakes: Build LaTeX Documents Reproducibly](https://flyx.org/nix-flakes-latex/)
- [A guide to supercharged mathematical typesetting](https://ejmastnak.com/tutorials/vim-latex/intro/)
