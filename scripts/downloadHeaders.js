const tar = require("tar");
const { Readable } = require("stream");


fetch(process.release.headersUrl)
	.then(r => {
		if (!r.ok) {
			throw new Error(`Failed to download headers: ${r.statusText}`);
		}
		Readable.fromWeb(r.body).pipe(tar.x({ cwd: "", strip: 1 }));
	})