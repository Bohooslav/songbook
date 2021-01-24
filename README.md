# Songbook Imba

Tiny songbook

## Getting started

```
git clone https://github.com/Bohooslav/songbook
cd songbook
yarn # npm install
```

You can run the app in two ways, either served via the webpack-dev-server or
Express.

### Webpack

```bash
# start webpack-dev-server and compiler
yarn run dev # npm run dev
```

### Server side

```
./node_modules/.bin/imba src/server.imba
```

[0]: https://github.com/css-modules/css-modules
[1]: https://github.com/imba/hello-world-imba/generate

### Before deploy:
 * update the version of servise worker (sw.js)
 * run `npm run build` to minimize the `client.js` and prepare it for the deploy.
 * Commit changes & push.