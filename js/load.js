const pathJoin = (...parts) => parts.join('/')
    .replace(/\/+/g, '/').replace(/\/[^/]+\/\.\.\//g, '/');

export async function loadManifest() {
    const manifest = JSON.parse(await fetch('src/manifest.json', {
        cache: 'no-cache',
    }).then((response) => response.text()));

    return {
        ...manifest,
        files: manifest.files?.map(path => ({
            storyPath: path,
            downloadPath: pathJoin('src/', path),
        })) ?? [],
    };
}

async function scanDirDeep(path) {
    const paths = [];
    try {
        const srcDoc = new DOMParser().parseFromString(await (await fetch(path)).text(), "text/html");
        for (const item of srcDoc.querySelectorAll("ul > li > a[href]")) {
            const itemPath = item.getAttribute("href");
            if (itemPath.endsWith(".ink")) {
                paths.push(pathJoin(path, itemPath));
            } else {
                paths.push(...(await scanDirDeep(pathJoin(path, itemPath))));
            }
        }
    } catch (e) {
        console.error(e);
    }
    return paths;
}
//await scanDirDeep(pathJoin(location.pathname, "src/"));