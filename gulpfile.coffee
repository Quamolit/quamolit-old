
gulp = require 'gulp'
gutil = require 'gulp-util'

project = 'workflow'
dev = yes
prefix = '/Quamolit/quamolit/dist/'
libraries = [
]

gulp.task 'folder', (cb) ->
  filetree = require 'make-filetree'
  filetree.make '.',
    'index.cirru': ''
    src:
      'main.coffee': ''
      'main.css': ''
    lib: {}
    'README.md': ''
    build: {}
  cb()

gulp.task 'watch', ->
  plumber = require 'gulp-plumber'
  coffee = require 'gulp-coffee'
  watch = require 'gulp-watch'
  html = require 'gulp-cirru-html'
  transform = require 'vinyl-transform'
  browserify = require 'browserify'
  rename = require 'gulp-rename'
  reloader = require 'gulp-reloader'
  reloader.listen()

  gulp
  .src 'index.cirru'
  .pipe watch()
  .pipe plumber()
  .pipe html(data: {dev: yes})
  .pipe gulp.dest('./')
  .pipe reloader(project)

  gulp
  .src 'src/**/*.coffee', base: 'src'
  .pipe watch()
  .pipe plumber()
  .pipe (coffee bare: yes)
  .pipe (gulp.dest 'lib/')
  .pipe rename('main.js')
  .pipe transform (filename) ->
    b = browserify filename, debug: yes
    b.external library for library in libraries
    b.bundle()
  .pipe gulp.dest('build/')
  .pipe reloader(project)

gulp.task 'coffee', ->
  coffee = require 'gulp-coffee'
  gulp
  .src 'src/**/*.coffee', base: 'src/'
  .pipe (coffee bare: yes)
  .pipe (gulp.dest 'lib/')

gulp.task 'html', ->
  html = require 'gulp-cirru-html'
  gulp
  .src 'index.cirru'
  .pipe html(data: {dev: dev})
  .pipe gulp.dest('.')

gulp.task 'browserify', ->
  browserify = require 'browserify'
  source = require 'vinyl-source-stream'
  buffer = require 'vinyl-buffer'
  uglify = require 'gulp-uglify'

  b = browserify debug: dev
  b.add './lib/main'
  b.external library for library in libraries
  jsStream = b.bundle()
  .pipe source('main.js')
  .pipe (if dev then gutil.noop() else buffer())
  .pipe (if dev then gutil.noop() else uglify())
  .pipe gulp.dest('build/')

gulp.task 'vendor', ->
  source = require 'vinyl-source-stream'
  uglify = require 'gulp-uglify'
  buffer = require 'vinyl-buffer'
  browserify = require 'browserify'

  b = browserify debug: no
  b.require library for library in libraries
  b.bundle()
  .pipe source('vendor.js')
  .pipe buffer()
  .pipe (if dev then gutil.noop() else uglify())
  .pipe gulp.dest('build/')

gulp.task 'prefixer', ->
  prefixer = require 'gulp-autoprefixer'

  gulp
  .src 'src/**/*.css', base: 'src/'
  .pipe prefixer()
  .pipe gulp.dest('lib/')

gulp.task 'cssmin', ->
  cssmin = require 'gulp-cssmin'

  gulp
  .src 'lib/main.css'
  .pipe cssmin(root: 'lib')
  .pipe gulp.dest('build/')

gulp.task 'clean', (cb) ->
  del = require 'del'
  del ['lib/', 'build/', 'dist/'], cb

gulp.task 'dist', (cb) ->
  rev = require 'pages-rev'

  rev.run
    base: "#{__dirname}/"
    dest: "#{__dirname}/dist/"
    entries: ['index.html']
    ignoreDirs: ['node_modules']
    prefix: prefix
  cb()

gulp.task 'start', (cb) ->
  sequence = require 'run-sequence'
  sequence 'clean', 'vendor', 'dev', cb

gulp.task 'dev', ->
  sequence = require 'run-sequence'
  sequence ['html', 'coffee', 'prefixer'], 'browserify'

gulp.task 'build', (cb) ->
  dev = no
  sequence = require 'run-sequence'
  sequence 'start', 'cssmin', cb

gulp.task 'rsync', (cb) ->
  rsync = require('rsyncwrapper').rsync
  rsync
    ssh: yes
    src: 'dist/'
    recursive: true
    args: ['--verbose']
    dest: "tiye:~/repo/#{project}"
    deleteAll: yes
    exclude: []
  , (error, stdout, stderr, cmd) ->
    if error? then throw error
    if stderr? then console.error stderr
    else console.log cmd
    cb()

gulp.task 'up', (cb) ->
  sequence = require 'run-sequence'
  prefix = '/quamolit/'
  sequence 'dist', 'rsync', cb
