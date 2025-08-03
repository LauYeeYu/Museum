# Personal Album

This is the repo for [my personal album][i-amwahtiam-org], which is a
collection of photos and videos.

[i-amwahtiam-org]: https://i.amwahtiam.org/

## Features

- Full screen photo on click
- Card view for albums
  - Cascade layout when the screen is wide
  - Cover image for each album
    - Need to be specified in the album parameters as "cover"
    - The recommended aspect ratio is 2000x1000 pixels (2:1).
    - It is recommended to name the cover image as "cover.webp".
- Smooth picture loading
  - A blurred thumbnail is shown while the full image is loading.
  - Once the full image is loaded, the blurred thumbnail will fade out
    (Safari have some issues in smooth loading, which leads to white splash).
  - The project also have a Makefile that generates the blurred thumbnail
    for all images in the `content/posts/` directory (`cover.*` will be
    skipped). This is useful to save compute power on deployment, especially
    when the deployment server does not have a powerful GPU.

## License

Unless otherwise stated, all rights reserved for the contents in `content/`
and `static/` directories.

For other files, they are licensed under the MIT License. See the
[LICENSE](LICENSE) file for details.
