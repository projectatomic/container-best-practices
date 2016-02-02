import sys
toc_file = open('toc.html','w')

for line in open('index.html'):
    if '<div id="content">' not in line:
        toc_file.write(line)
    else:
        toc_file.write("</body>")
        toc_file.write("</html>")
        toc_file.close()
        sys.exit()
