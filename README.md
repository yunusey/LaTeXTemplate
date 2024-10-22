<h1 align="center"> LaTeX Template ✨ </h1>
<div align="center" border-radius="20px">
    <img src="./assets/latex-template-logo.png" width="200" height="200" />
</div>

*This is a nice little LaTeX template that uses GitHub actions for automated builds and Nix for managing dependencies.*

## Showcase 📸
You can see the compiled versions of the PDFs in the [artifacts](https://github.com/yunusey/latextemplate/blob/artifacts) branch:

- [Template (tex)](./Template/template.tex) & [Template (pdf)](https://github.com/yunusey/latextemplate/blob/artifacts/Template/template.pdf)
- [Example (tex)](./Example/Example.tex) & [Example (pdf)](https://github.com/yunusey/latextemplate/blob/artifacts/Example/Example.pdf)

## Usage 📝
You can fork the repository and quickly begin using it. If you are a student like me and you are writing your assignments in $\LaTeX$, you can create a folder inside the root, named `./MyClass`, copy the template using `cp ./Template/template.tex ./MyClass/MyAssignment.tex`, and begin writing. After you are done, just push your changes and you will see (under Actions in your repository) that the build started. Once it is done building, you can download your artifacts or read it on GitHub by switching to `artifacts`.

## Why Automated Builds? ⚙️
I write my assignments and sometimes take my notes in $\LaTeX$, because the result it amazing and I really like it, and feel the need to take a look at my notes/assignments whenever I need them. Using this integrated setup, whenever I make changes to something, GitHub actions builds my project and pushes the artifacts to the `artifacts` branch. So, I can always read them, from my phone or any other device that is able to connect to internet.

## Why Nix? ❄️
I am a NixOS user and really love Nix package manager. I think it does an awesome job on managing $\LaTeX$ dependencies as well!

### Adding new fonts 🔤
You can add new fonts to use in your $\LaTeX$ project. To do so, open [your flake file](./flake.nix), you are going to see the following line:

```nix
os_font_dir = with pkgs; "${jetbrains-mono}/share/fonts/truetype:${vollkorn}/share/fonts/opentype";
```
Now, let's say you want to use `Fira Code` font, then you are going to want to find it on [NixOS Search](search.nixos.org). For instance, for `Fira Code`, I found my font's package to be `fira-code`. Now, I can look at what kind of a font it is (it is truetype and located at `$out/share/fonts/truetype` - you can see it in the [source](https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/fira-code/default.nix#L24)), so I will change this line to:

```nix
os_font_dir = with pkgs; "${jetbrains-mono}/share/fonts/truetype:${vollkorn}/share/fonts/opentype:${fira-code}/share/fonts/truetype";
```

Then, if you are using my template, you should go to [./Modules/fonts.tex](./Modules/fonts.tex), and add the following lines:
```tex
\newfontfamily{\firacode}{FiraCode-VF}[
	Extension=.ttf,
	Ligatures = TeX,
	Scale=0.9
]
```
Now, you can use `firacode` in your $\LaTeX$ project like this:

```tex
\begin{myenvironment}
{
\firacode

This is my code with Fira Code font
}
\end{myenvironment}
```

If you have local font files, as long as you add them to your `$OSFONTDIR` environment variable, and declare add them using `fontspec` in your $\LaTeX$ project, you will be able to use them in your project.

### Adding new packages 📦
Adding new packages, if they are in TeXLive, is pretty easy. You just need to find its name, search on [NixOS Search](search.nixos.org) and add it to your flake file like this:

```nix
tex = pkgs.texlive.combine {
  inherit (pkgs.texlive) scheme-medium latexmk {some other packages...} my-awesome-package;
};
```

### What should I do if the package is not in TeXLive or I couldn't find it in [NixOS Search](search.nixos.org)? 🤔
First of all, don't worry! In your root, you are going to find a folder named `./packages` which you can rename to whatever you want (`styles` could be a good name). Then, you are going to want to download and copy the `sty` files into this folder. If you look at the contents of [packages](./packages), you are going to see that there already is a file named [catppuccinpalette.sty](./packages/catppuccinpalette.sty). Even though this package is in TeXLive, it wasn't uploaded to [nixpks](https://github.com/nixos/nixpkgs), and I downloaded the `sty` file from [CTAN](https://www.ctan.org/pkg/catppuccinpalette) and copied it to [packages](./packages) folder. Then, I was able to use it just like any other package:

```tex
\usepackage[mocha]{catppuccinpalette}
```

If you have many different folders placed in different locations, maybe one of them is not even in your project folder, you can manually change the environment variable `$TEXINPUTS` to include all of them.

## How am I using it? 🚀
I am a Neovim user (love it!) and I use [Zathura](https://github.com/pwmt/zathura) to view PDFs, [VimTex](https://github.com/lervag/vimtex) as a general purpose Neovim plugin that integrates $\LaTeX$ and Neovim (it is awesome!), and [TexLab](https://github.com/latex-lsp/texlab) as my LSP (it is pretty awesome as well). I also have several snipets, even though I try to avoid them as much as possible, which is why I am using [LuaSnip](https://github.com/L3MON4D3/LuaSnip). My dotfiles are private, but you can see how you can configure these plugins and language servers to your Neovim setup in their documentation, and I think **most definitely** you should take a look at [this guide](https://ejmastnak.com/tutorials/vim-latex/intro/) by [ejmastnak](https://github.com/ejmastnak)!

## Building Files Locally 🔄
Just run `nix build`, and you are going to see the generated PDFs in the `./result/out` folder (this folder is gitignored).

## Development Environment 🛠️
You can run `nix develop` to start a devshell with your packages and dependencies declared in your flake file. If you are using [direnv](https://github.com/direnv/direnv), you can also run `direnv allow` to automatically start a devshell everytime you `cd` into your project folder.

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

## Reading List 📚
- [Exploring Nix Flakes: Build LaTeX Documents Reproducibly](https://flyx.org/nix-flakes-latex/)
- [A guide to supercharged mathematical typesetting](https://ejmastnak.com/tutorials/vim-latex/intro/)
