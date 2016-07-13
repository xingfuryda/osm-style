filePath = '/home/root/mapbox-studio-classic/app/style.css'

f = open(filePath, 'r')
contents = f.readlines()
f.close()

del contents[111]
del contents[111]
contents.insert(111, '  padding-left: 0px;\n')
contents.insert(111, '  width: 32px;\n')
contents.remove('.carto-tabs a.tab.active .deltab { display:block;}\n')
contents.insert(123, '.carto-tabs a.tab.active .deltab { display:none;}\n')

f = open(filePath, 'w')
contents = ''.join(contents)
f.write(contents)
f.close()