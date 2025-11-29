#!/usr/bin/env python3

"""
Generates preview images for the example documents in the Examples/ folder.
"""

import os
import subprocess

ASSETS_DIR = os.path.dirname(__file__)
ROOT_DIR = os.path.dirname(ASSETS_DIR)
EXAMPLES_DIR = os.path.join(ROOT_DIR, "Example")
PREVIEW_SUFFIX = " Preview.png"


def generate_previews():
    """
    This function will assume that the PDF files are already generated from the
    .tex files, and are located in the same directory as the .tex files.
    """
    for filename in os.listdir(EXAMPLES_DIR):
        if filename.endswith(".tex"):
            tex_path = os.path.join(EXAMPLES_DIR, filename)
            preview_path = os.path.join(
                ASSETS_DIR, filename.replace(".tex", PREVIEW_SUFFIX)
            )

            pdf_path = tex_path.replace(".tex", ".pdf")

            # Convert the first page of the PDF to PNG
            subprocess.run(
                [
                    "convert",
                    "-density",
                    "150",
                    f"{pdf_path}[0]",
                    "-quality",
                    "90",
                    preview_path,
                ],
                check=True,
            )


if __name__ == "__main__":
    generate_previews()
