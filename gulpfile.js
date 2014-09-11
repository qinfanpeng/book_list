// 引入 gulp
var gulp = require('gulp');
var jade = require('gulp-jade');

var less = require('gulp-less');
var path = require('path');

var dest = 'dist';

var livereload = require('gulp-livereload');

var coffee = require('gulp-coffee');

gulp.task('compile_jade_templates', function() {
    var YOUR_LOCALS = {};

    gulp.src('./templates/*.jade')
      .pipe(jade({
        locals: YOUR_LOCALS
      }))
      .pipe(gulp.dest('./dist/'))
    });

gulp.task('compile_less', function () {
  gulp.src('./less/**/*.less')
    .pipe(less({
      paths: [ path.join(__dirname, 'less', 'includes') ]
    }))
    .pipe(gulp.dest('./dist/style/'));
});

gulp.task('compile_coffee', function() {
  gulp.src('./coffee/*.coffee')
   .pipe(coffee())
  .pipe(gulp.dest('./dist/script/'))
});

gulp.task('server', function(next) {
  var connect = require('connect'),
      server = connect();
  server.use(connect.static(dest)).listen(process.env.PORT || 80, next);
});

gulp.task('copy_jquery_to_script_folder', function(next) {
  gulp.src('./bower_components/jquery/dist/jquery.min.js')
  .pipe(gulp.dest('./dist/script/'));
});

// 默认任务
gulp.task('default', ['server'], function() {
    var server = livereload();

    gulp.watch(['./templates/*.jade'], ['compile_jade_templates']);

    gulp.watch(['./less/*.less'], ['compile_less']);

    gulp.watch(['./coffee/*.coffee'], ['compile_coffee']);

    gulp.watch('dist/**').on('change', function(file) {
      server.changed(file.path);
    });
});