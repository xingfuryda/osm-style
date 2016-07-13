filePath = '/home/root/projects/openstreetmap-carto-vector-tiles/project.yaml'

f = open(filePath, 'r')
contents = f.readlines()
f.close()

contents.insert(33, '    user: "postgres"\n')
contents.insert(33, '    host: "store"\n')
contents.insert(33, '    password: "password1"\n')

f = open(filePath, 'w')
contents = ''.join(contents)
f.write(contents)
f.close()