import { type Build } from 'cmake-ts-gen';

const build: Build = {
    common: {
        project: 'libsndfile',
        archs: ['x64'],
        variables: [],
        copy: {},
        defines: [],
        options: [
            ['WEBP_BUILD_CWEBP', false],
            ['WEBP_BUILD_DWEBP', false],
            ['WEBP_BUILD_GIF2WEBP', false],
            ['WEBP_BUILD_IMG2WEBP', false],
            ['WEBP_BUILD_VWEBP', false],
            ['WEBP_BUILD_WEBPINFO', false],
            ['WEBP_BUILD_WEBPMUX', false],
        ],
        subdirectories: ['libwebp'],
        libraries: {
            webp: { name: 'libwebp' },
            sharpyuv: { name: 'libsharpyuv' },
            webpdecoder: { name: 'libwebpdecode' },
            imageenc: { name: 'libimageenc' },
            imagedec: { name: 'libimagedec' },
            libwebpmux: { name: 'libwebpmux' },
            webpdemux: { name: 'libwebpdemux' },
        },
        buildDir: 'build',
        buildOutDir: '../libs',
        buildFlags: []
    },
    platforms: {
        win32: {
            windows: {},
            android: {
                archs: ['x86', 'x86_64', 'armeabi-v7a', 'arm64-v8a'],
            }
        },
        linux: {
            linux: {}
        },
        darwin: {
            macos: {}
        }
    }
}

export default build;