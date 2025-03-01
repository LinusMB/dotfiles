#!/usr/bin/env python3

import argparse
import tempfile
import webbrowser
from string import Template

page = r'''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Image Viewer</title>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body>
      <div x-data="{
        images: [
          $image_sources
        ],
        current: 0,
        prev() { this.current = (this.current === 0) ? this.images.length - 1 : this.current - 1; },
        next() { this.current = (this.current === this.images.length - 1) ? 0 : this.current + 1; },
      }"
      >
        <div class="fixed inset-0 flex items-center justify-center bg-gray-200">
            <button @click="prev" class="absolute left-4 bg-black bg-opacity-50 rounded-full hover:bg-opacity-80">
                <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
                </svg>
            </button>

            <img class="object-contain w-4/5 h-4/5 rounded shadow-xl" :src="images[current].src" />

            <button @click="next" class="absolute right-4 bg-black bg-opacity-50 rounded-full hover:bg-opacity-80">
                <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                </svg>
            </button>
        </div>
      </div>
  </body>
</html>
'''

def main(filenames):
    template = Template(page)

    image_sources = ", ".join("{ src: 'file://" + file + "' }" for file in filenames)

    content = template.substitute(image_sources=image_sources)

    with tempfile.NamedTemporaryFile('w', delete=False, suffix='.html') as f:
        f.write(content)
        fpath = f.name

    browser = webbrowser.get()
    browser.open(fpath)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("filenames", nargs="+")
    args = parser.parse_args()
    main(args.filenames)
