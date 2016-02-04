import os
import sys
import subprocess
import argparse
import shutil

class ChangeReview(object):
    def __init__(self, filenames):
        self.files = filenames
        self.check_file_names()
        #self.files = ['planning/planning_index.adoc', 'creating/creating_index.adoc']
        self.projdir = os.getcwd()
        self.outdir = os.path.join(self.projdir, 'output')

    def check_file_names(self):
        for fname in self.files:
            if not (fname.endswith(".adoc") or fname.endswith(".asciidoc")):
                sys.exit("{} does not end in .adoc or .asciidoc".format(fname))
            if not os.path.exists(fname):
                sys.exit("Unable to find {}".format(fname))

    def process_file(self):
        for fname in self.files:
            if self.create_original(fname):
                if self.create_patch(fname):
                    self.patch_file(fname)

    def create_original(self, cfile):
        basename = os.path.basename(cfile)
        outdir = os.path.join(self.outdir, os.path.dirname(cfile))
        cmd = ['git', 'show', 'HEAD~1:{}'.format(cfile)]
        print cmd
        result = subprocess.Popen(cmd, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
        stdout, stderr = result.communicate()
        if not os.path.exists(outdir):
            os.makedirs(outdir)
        if result.returncode != 0:
            foo = subprocess.Popen(['pwd'])
            foo.communicate()
            shutil.copyfile(os.path.join(self.projdir, cfile), os.path.join(outdir, os.path.basename(cfile)))
            return False
        output = open(os.path.join(outdir, basename), 'w')
        output.write(stdout)
        output.close()
        return True

    def create_patch(self, cfile):
        outdir = os.path.join(self.outdir, os.path.dirname(cfile))
        basename = os.path.basename(cfile)
        cmd = ['git', 'diff', 'HEAD~1', cfile]
        foo = subprocess.check_output(cmd)
        if foo == '':
            return False
        new_file_lines = []
        for line in foo.splitlines():
            if line.startswith('+') and not line.startswith('++'):
                new_file_lines.append(line[:1] + '[aqua-background]##' + line[1:] + "##")
            else:
                new_file_lines.append(line)
        output = open(os.path.join(outdir, basename + '.patch'), 'w')
        output.write("\n".join(new_file_lines) + "\n")
        output.close()
        return True

    def patch_file(self, cfile):
        outdir = os.path.join(self.outdir, os.path.dirname(cfile))
        basename = os.path.basename(cfile)
        os.chdir(outdir)
        print os.curdir
        cmd = ['patch', '-p1', basename, basename + '.patch']
        subprocess.check_call(cmd)


parser = argparse.ArgumentParser(description='Change markup based on a diff')
parser.add_argument('filenames', nargs='+', help='filenames')
args = parser.parse_args()

cr = ChangeReview(args.filenames)
cr.process_file()

