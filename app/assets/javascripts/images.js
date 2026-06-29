// Legacy UI helpers (used by the legacy upload form, not the modern UI)

function cycleDemoImages() {
  var img = document.querySelector('.intro .left img');
  if (!img) return;
  var match = img.getAttribute('src').match(/\d/);
  if (!match) return;
  var id = parseInt(match[0]) + 1;
  if (id > 6) id = 1;
  document.querySelector('.intro .left img').setAttribute('src', '/demo' + id + '.jpg');
  document.querySelector('.intro .right img').setAttribute('src', '/demo' + id + '-soft.jpg');
}

function previewFile(e, file) {
  var errorEl = document.querySelector('.intro .left .error');
  if (errorEl) errorEl.remove();
  var img = document.querySelector('.intro .left img');
  if (!img) return;
  if (file.type.match('image.*')) {
    img.setAttribute('src', e.target.result);
  } else {
    img.setAttribute('src', '/error.png');
  }
  var nextDemo = document.getElementById('next_demo');
  if (nextDemo) nextDemo.style.display = 'none';
}

function showUploadProgress(e) {
  if (!e.lengthComputable) return;
  var pct = (e.loaded / e.total) * 100;
  var bar = document.getElementById('upload-progress');
  if (!bar) return;
  bar.style.display = '';
  bar.setAttribute('value', pct);
  if (pct >= 100) {
    bar.style.display = 'none';
    var proc = document.getElementById('process-progress');
    if (proc) proc.style.display = '';
  }
}

function onProcessed(e, file, response) {
  var proc = document.getElementById('process-progress');
  if (proc) proc.style.display = 'none';
  var obj = JSON.parse(response);
  if (obj.id) {
    window.location = '/' + obj.id;
  } else {
    var img = document.querySelector('.intro .left img');
    if (img) img.setAttribute('src', '/error.png');
    var left = document.querySelector('.intro .left');
    if (left) {
      var div = document.createElement('div');
      div.className = 'error';
      div.textContent = obj.error;
      left.appendChild(div);
    }
  }
}
