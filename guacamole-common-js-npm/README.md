# guacamole-js-sdk

npm package wrapping the [Apache Guacamole](https://guacamole.apache.org/) JavaScript client library, built automatically from the official open-source release. **No source code has been modified** — this is a straight repackage of the upstream `guacamole-common-js` bundle for easy consumption via npm.

## Installation

```bash
npm install guacamole-js-sdk
```

## Usage

### Browser (via bundler)

```js
import Guacamole from 'guacamole-js-sdk';
// or
const Guacamole = require('guacamole-js-sdk');
```

### Browser (direct script tag)

```html
<script src="node_modules/guacamole-js-sdk/dist/all.min.js"></script>
```

### Example

```js
const Guacamole = require('guacamole-js-sdk');

const tunnel = new Guacamole.WebSocketTunnel('wss://your-guacd-host/tunnel');
const client = new Guacamole.Client(tunnel);

document.body.appendChild(client.getDisplay().getElement());
client.connect();
```

## Package contents

| File | Description |
|------|-------------|
| `dist/all.js` | Full unminified bundle |
| `dist/all.min.js` | Minified bundle |
| `index.js` | CommonJS entry point with Node.js polyfills |

## Versioning

Package version matches the upstream Guacamole release (e.g. `1.6.1`).

## Source & attribution

Built from [apache/guacamole-client](https://github.com/apache/guacamole-client). No code in this package has been modified from the upstream Apache release. This package is not affiliated with or endorsed by the Apache Software Foundation.

## License

Apache-2.0 — see [upstream project](https://github.com/apache/guacamole-client).
