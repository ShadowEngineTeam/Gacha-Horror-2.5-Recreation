import os
import subprocess
import argparse
from PIL import Image
import sys

def get_astcenc_path():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    exe_name = "astcenc.exe" if os.name == "nt" else "astcenc"
    astcenc_path = os.path.join(script_dir, exe_name)
    if not os.path.isfile(astcenc_path):
        print(f"Error: '{exe_name}' not found. Please install it from https://github.com/ARM-software/astc-encoder/releases")
        sys.exit(1)
    return astcenc_path

def run_command(command):
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")

def parse_args():
    parser = argparse.ArgumentParser(description="Compress images in a folder using astcenc.")
    parser.add_argument('-i', '--input', required=True, help="Input folder containing PNG images.")
    parser.add_argument('-o', '--output', required=True, help="Output folder for ASTC compressed images.")
    return parser.parse_args()

def main():
    args = parse_args()
    input_folder = args.input
    output_folder = args.output

    if not os.path.isdir(input_folder):
        print(f"The input folder '{input_folder}' does not exist.")
        return

    os.makedirs(output_folder, exist_ok=True)

    astcenc_tool = get_astcenc_path()

    for root, dirs, files in os.walk(input_folder):
        for file in files:
            if file.lower().endswith(".png"):
                input_path = os.path.join(root, file)

                rel_path = os.path.relpath(root, input_folder)
                output_dir = os.path.join(output_folder, rel_path)
                os.makedirs(output_dir, exist_ok=True)
                output_path = os.path.join(output_dir, file.replace(".png", ".astc"))

                with Image.open(input_path) as img:
                    width, height = img.size

                block_size = "4x4" if width <= 512 and height <= 512 else "8x8"

                command = [
                    astcenc_tool,
                    "-cl",
                    input_path,
                    output_path,
                    block_size,
                    "-thorough",
                    "-perceptual"
                ]

                print(f"Compressing {file} ({width}x{height}) -> {output_path} with block size {block_size}...")
                run_command(command)

    print("Processing complete.")

if __name__ == "__main__":
    main()
