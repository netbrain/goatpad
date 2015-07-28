var BowerWebpackPlugin = require("bower-webpack-plugin");
var webpack = require('webpack');
module.exports = {
    entry: './app/index',
    output: {
        path: __dirname + '/build',
        filename: 'bundle.js'
    },
    plugins: [
        new webpack.ProvidePlugin({
            riot: 'riot'
        }),
        new BowerWebpackPlugin(),
        //new webpack.optimize.UglifyJsPlugin({
        //  minimize: true
        //}),
    ],
    module: {
        preLoaders: [{
            test: /\.tag$/,
            exclude: /node_modules/,
            loader: 'riotjs-loader',
            query: {
                type: 'none'
            }
        }],
        loaders: [{
            test: /\.js|\.tag$/,
            exclude: /node_modules/,
            loader: '6to5-loader'
        },{
            test: /\.css$/,
            loader: "style-loader!css-loader"
        }]
    },
    devServer: {
        contentBase: './build'
    }
};