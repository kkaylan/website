### Build and deploy http://kbkaylan.net

### If you want to use this file as-is, then you
### need to change the variables below to your
### own SSH user, document root, etc.
### However, you will most likely also want to
### customize the various steps (e.g. the css target)
### so that it matches the details of your own
### setup.
###
### Apart from hugo, you will also need rsync to deploy
### the site, and the java-based yuicompressor to
### minify the CSS, should you keep that step.


SSH_USER = kbkaylan_kbkaylan@ssh.phx.nearlyfreespeech.net
DOCUMENT_ROOT = /home/public/
PUBLIC_DIR = public/

all: deploy

server: css
	hugo server -ws .

deploy: compress site
	rsync -crzve 'ssh -p 22' $(PUBLIC_DIR) $(SSH_USER):$(DOCUMENT_ROOT)

compress: css
	java -jar bin/yuicompressor-2.4.8.jar static/css/stylesheet.css -o static/css/stylesheet-min.css --charset utf-8

site: css .FORCE
	hugo
	find public -type d -print0 | xargs -0 chmod 755
	find public -type f -print0 | xargs -0 chmod 644

css:
	touch static/css/stylesheet.css
	rm -f static/css/stylesheet.css
	cat static/css/kube.css static/css/demo.css static/css/syntax.css static/css/bigfoot-default.css > static/css/stylesheet.css

clean:
	rm -rf public/

.FORCE:
