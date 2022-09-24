// rollup.config.js
import path from 'node:path';
import resolve from '@rollup/plugin-node-resolve';
import json from '@rollup/plugin-json';
import jsx from 'acorn-jsx';
import babel from '@rollup/plugin-babel';
import typescript from '@rollup/plugin-typescript';
import scss from 'rollup-plugin-scss';
import copy from 'rollup-plugin-copy';
import replace from 'rollup-plugin-replace';
import packageJson from './package.json';

export default {
  external: [
    "inferno",
    "inferno-animation",
    "component-registry",
    "socket-io-client",
    "simple-peer"
  ],
  input: './_streamixSrc/package.ts',
  output: {
    file: path.resolve('build', packageJson.name, 'package.js'),
    format: 'iife',
    globals: {
      "inferno": "Inferno",
      "inferno-animation": "InfernoAnimation",
      "component-registry": "ComponentRegistry",
      "socket-io-client": "SocketIOClient",
      "simple-peer": "SimplePeer"
    }
  },
  acornInjectPlugins: [jsx()],
  plugins: [
    replace({
      'process.env.NODE_ENV': JSON.stringify('production')
    }),
    resolve(),
    json(),
    typescript({
      compilerOptions: {
        esModuleInterop: true,
        isolatedModules: true,
        resolveJsonModule: true,
        moduleResolution: "Node",
        jsx: "preserve",
        lib: [
          "dom",
          "es2020"
        ],
        types: [
          "inferno",
          "node"
        ],
      }
    }),
    babel({
      babelHelpers: 'bundled',
      extensions: ['.js', '.jsx', '.es6', '.es', '.mjs', '.ts', '.tsx']
    }),
    scss({
      output: path.resolve('build', packageJson.name, 'package.css'),
      failOnError: true,
      runtime: require("sass"),
    }),
    copy({
      targets: [
        { src: 'assets/*', dest: path.resolve('build', packageJson.name) },
        { src: 'src/streamix_package.json', dest: path.resolve('build', packageJson.name) }
      ]
    })
  ]
};
