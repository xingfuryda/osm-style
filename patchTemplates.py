# fixes the stripping of minzoom maxzoom after saving a tmsource

filePath = '/home/root/mapbox-studio-classic/templates/layerpostgis.html'

f = open(filePath, 'r')
contents = f.readlines()
f.close()

contents.insert(84, '        <% if (obj.properties[\'minzoom\']) { %>\n')
contents.insert(85, '        <input type=\'hidden\' name=\'properties-minzoom\' value=\'<%=obj.properties[\'minzoom\']%>\' />\n')
contents.insert(86, '        <% } %>\n')
contents.insert(87, '        <% if (obj.properties[\'maxzoom\']) { %>\n')
contents.insert(88, '        <input type=\'hidden\' name=\'properties-maxzoom\' value=\'<%=obj.properties[\'maxzoom\']%>\' />\n')
contents.insert(89, '        <% } %>\n')

f = open(filePath, 'w')
contents = ''.join(contents)
f.write(contents)
f.close()


filePath = '/home/root/mapbox-studio-classic/templates/layershape.html'

f = open(filePath, 'r')
contents = f.readlines()
f.close()

contents.insert(46, '        <% if (obj.properties[\'minzoom\']) { %>\n')
contents.insert(47, '        <input type=\'hidden\' name=\'properties-minzoom\' value=\'<%=obj.properties[\'minzoom\']%>\' />\n')
contents.insert(48, '        <% } %>\n')
contents.insert(49, '        <% if (obj.properties[\'maxzoom\']) { %>\n')
contents.insert(50, '        <input type=\'hidden\' name=\'properties-maxzoom\' value=\'<%=obj.properties[\'maxzoom\']%>\' />\n')
contents.insert(51, '        <% } %>\n')

f = open(filePath, 'w')
contents = ''.join(contents)
f.write(contents)
f.close()