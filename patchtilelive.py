filePath = '/home/root/tessera/node_modules/tilelive-tmstyle/index.js'

f = open(filePath, 'r')
contents = f.readlines()
f.close()

contents.insert(48, '  tm.fname = fname;\n')
del contents[210]
contents.insert(210, '        var xmlname = tm.fname.replace(\'project.yml\', \'project.xml\');\n')
contents.insert(211, '        var resultxml = \'\';\n')
contents.insert(212, '        if (fs.existsSync(xmlname)) {\n')
contents.insert(213, '          resultxml = fs.readFileSync(xmlname,\'utf8\');\n')
contents.insert(214, '        } else {\n')
contents.insert(215, '          resultxml = new carto.Renderer().render(opts);\n')
contents.insert(216, '          fs.writeFileSync(xmlname, resultxml);\n')
contents.insert(217, '        }\n')
contents.insert(218, '        return callback(null, resultxml);\n')


f = open(filePath, 'w')
contents = ''.join(contents)
f.write(contents)
f.close()