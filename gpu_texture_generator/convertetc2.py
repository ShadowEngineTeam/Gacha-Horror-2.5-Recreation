import os
import subprocess
import argparse
from PIL import Image
import sys
import numpy as np

def get_compressonator_path():
    exe = "compressonatorcli/compressonatorcli"

    script_dir = os.path.dirname(os.path.abspath(__file__))
    local_path = os.path.join(script_dir, exe)

    if os.path.isfile(local_path):
        return local_path

    return exe


def run_command(command):
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Batch compress PNGs to ETC2 using CompressonatorCLI."
    )
    parser.add_argument("-i", "--input", required=True,
                        help="Input folder containing PNG images.")
    parser.add_argument("-o", "--output", required=True,
                        help="Output folder for KTX files.")
    return parser.parse_args()


def compute_edge_energy(img):
    gray = img.convert("L")
    arr = np.array(gray, dtype=np.int16)
    diff_h = np.abs(np.diff(arr, axis=0))
    diff_v = np.abs(np.diff(arr, axis=1))
    return float(np.mean(diff_h) + np.mean(diff_v))

def premultiply_alpha(img):
    if img.mode != "RGBA":
        return img

    arr = np.array(img, dtype=np.float32)
    alpha = arr[..., 3:4] / 255.0
    arr[..., :3] *= alpha
    arr = np.clip(arr, 0, 255).astype(np.uint8)
    return Image.fromarray(arr, mode="RGBA")


def main():
    args = parse_args()
    input_folder = args.input
    output_folder = args.output

    if not os.path.isdir(input_folder):
        print(f"The input folder '{input_folder}' does not exist.")
        return

    os.makedirs(output_folder, exist_ok=True)

    cli = get_compressonator_path()

    for root, dirs, files in os.walk(input_folder):
        for file in files:
            if not file.lower().endswith(".png"):
                continue

            input_path = os.path.join(root, file)
            rel_path = os.path.relpath(root, input_folder)
            output_dir = os.path.join(output_folder, rel_path)
            os.makedirs(output_dir, exist_ok=True)

            output_path = os.path.join(
                output_dir, file.replace(".png", ".ktx")
            )

            with Image.open(input_path) as img:
                width, height = img.size
                edge_energy = compute_edge_energy(img)
                img = premultiply_alpha(img)

                temp_path = os.path.join(output_dir, "_temp.png")
                img.save(temp_path)

            quality = pick_quality(width, height, edge_energy)

            command = [
                "bash",
                cli,
                "-fd", "ETC2_RGBA", # COMPRESSED_RGBA2_ETC2_EAC
                "-nomipmap",
                "-CompressionSpeed", "0", # 0 = slow/best, 2 = good balance, 4 = fastest
                temp_path,
                output_path
            ]

            print(
                f"Compressing {file} "
                f"({width}x{height}, edge={edge_energy:.2f}) "
                f"to {output_path}"
            )

            run_command(command)
            os.remove(temp_path)

    print("Processing complete.")


if __name__ == "__main__":
    main()
