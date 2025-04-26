import os
import re
import shutil
import datetime
from pathlib import Path
import glob

# Define the root directory of your Obsidian vault
VAULT_ROOT = "/home/liuning/Documents/Obsidian Vault/"  # Change this to your actual vault path if needed
ATTACHMENT_DIR = os.path.join(VAULT_ROOT, "Attachments", "all-vault-images")

def extract_timestamp(filename):
    """Extract timestamp from a 'Pasted image YYYYMMDDHHMMSS' filename"""
    match = re.search(r'Pasted image (\d{4})(\d{2})(\d{2})(\d{6})\.', filename)
    if match:
        year, month, day, time = match.groups()
        return f"{year}-{month}-{day}"
    return None

def find_markdown_file_for_image(image_path):
    """Find which markdown file references this image"""
    image_filename = os.path.basename(image_path)

    # Look for markdown files that reference this image (with Obsidian format)
    for md_file in glob.glob(os.path.join(VAULT_ROOT, "**", "*.md"), recursive=True):
        with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
            try:
                content = f.read()
                # Check for Obsidian-style references: ![[Pasted image...]]
                if f"![[{image_filename}]]" in content:
                    return md_file
            except Exception as e:
                print(f"Error reading {md_file}: {e}")

    return None

def get_md_title(md_path):
    """Extract title from markdown file path"""
    if not md_path:
        return "Unknown"

    filename = os.path.basename(md_path)
    title = os.path.splitext(filename)[0]
    return title

def organize_images():
    """Main function to organize images"""
    # Find all pasted images
    pasted_images = []
    for root, _, files in os.walk(VAULT_ROOT):
        for file in files:
            if file.startswith("Pasted image ") and any(file.endswith(ext) for ext in ['.png', '.jpg', '.jpeg', '.webp']):
                pasted_images.append(os.path.join(root, file))

    print(f"Found {len(pasted_images)} pasted images")

    # Process each image
    for image_path in pasted_images:
        try:
            image_filename = os.path.basename(image_path)
            date_folder = extract_timestamp(image_filename)

            if not date_folder:
                print(f"Could not extract date from {image_filename}, skipping")
                continue

            # Find which markdown file references this image
            md_file = find_markdown_file_for_image(image_path)
            md_title = get_md_title(md_file)

            # Create nested directory structure
            new_folder = os.path.join(ATTACHMENT_DIR, date_folder, md_title)
            os.makedirs(new_folder, exist_ok=True)

            # Generate new filename with the markdown title included
            file_ext = os.path.splitext(image_filename)[1]
            new_filename = f"Inserted {md_title}-image at {date_folder.replace('-', ' ')} {image_filename[20:-4].replace('-', '-')}{file_ext}"
            new_path = os.path.join(new_folder, new_filename)

            # Move the file
            print(f"Moving {image_path} to {new_path}")
            shutil.copy2(image_path, new_path)  # Use copy2 to preserve metadata

            # Update links in markdown files
            if md_file:
                update_markdown_links(md_file, image_filename, os.path.relpath(new_path, os.path.dirname(md_file)))
                # After successful update and copy, remove the original
                os.remove(image_path)
                print(f"Successfully processed and removed {image_filename}")
            else:
                print(f"Warning: No markdown file found for {image_filename}, file copied but original not removed")

        except Exception as e:
            print(f"Error processing {image_path}: {e}")

def update_markdown_links(md_file, old_filename, new_relative_path):
    """Update image links in markdown file"""
    try:
        with open(md_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # Replace Obsidian-style image links: ![[Pasted image...]]
        obsidian_pattern = rf'!\[\[{re.escape(old_filename)}\]\]'

        # Make sure we use forward slashes for paths in markdown
        new_path_normalized = new_relative_path.replace('\\', '/')

        # Replace with new Obsidian-style link
        content = re.sub(obsidian_pattern, f'![[{new_path_normalized}]]', content)

        # Also check for standard markdown links in case they exist
        md_patterns = [
            rf'!\[\]\({re.escape(old_filename)}\)',  # ![](Pasted image...)
            rf'!\[.*?\]\({re.escape(old_filename)}\)'  # ![any alt text](Pasted image...)
        ]

        for pattern in md_patterns:
            content = re.sub(pattern, f'![[{new_path_normalized}]]', content)

        with open(md_file, 'w', encoding='utf-8') as f:
            f.write(content)

        print(f"Updated links in {md_file}")

    except Exception as e:
        print(f"Error updating links in {md_file}: {e}")

if __name__ == "__main__":
    # Create attachment directory if it doesn't exist
    os.makedirs(ATTACHMENT_DIR, exist_ok=True)

    # Run the organization function
    organize_images()

    print("Image organization complete!")
