
var fs = require('fs');

var namespace = process.argv[2];
var cdn = process.argv[3];
namespace = namespace.split('.');

var main = namespace.join('/').replace(/\/main/, '') + '/main.css';

var deps = fs.readFileSync('../' + main, 'utf-8');
deps = parseDeps(deps);

deps = deps.map(function(item) {
  return item.match(/url\(['"]?.*css\/([^\(]*)['"]?\)/)[1];  
});

var str = compile(deps);

console.log(str);

/*
namespace.shift();
var ver = (new Date).getTime().toString(36);
var out = '../build/' + namespace.join('/') + '-' + ver + '.css';
fs.writeFileSync(out, str, 'utf-8');
*/

function parseDeps(str) {
  return str.match(/url\(['"]?([^\(]*)['"]?\)/g);
}

function compile(files) {
  return files.map(function(item) {
    return fs.readFileSync('../css/' + item, 'utf-8');
  }).join('').replace(/\s+/g, ' ').replace(/\/\*(.*?)\*\//g, '')
    .replace(/\{ /g, '{').replace(/ \}/g, '}')
    .replace(/[\.\/]*images/g, cdn);
}


