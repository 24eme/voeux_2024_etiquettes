<?php
  $cuvee = isset($_GET['cuvee']) ? $_GET['cuvee'] : null;
  $histoire1 = isset($_GET['histoire1']) ? $_GET['histoire1'] : null;
  $histoire2 = isset($_GET['histoire2']) ? $_GET['histoire2'] : null;

  shell_exec("bash bin/generate.sh \"$cuvee\" \"$histoire1\" \"$histoire2\"");
?>
<!doctype html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Voeux 2024</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
</head>
<body>
  <div class="container">
    <form action="" method="GET">
    <div class="row pt-3 pb-3 bg-light sticky-top border rounded-bottom shadow-sm">
      <div class="col-2">
        <div class="form-floating">
          <input type="text" name="cuvee" class="form-control" id="input_cuvee" value="<?php echo $cuvee ?>">
          <label for="floatingInput">Cuvée</label>
        </div>
      </div>
      <div class="col-4">
        <div class="form-floating">
          <input required="required" type="text" name="histoire1" id="input_histoire1" class="form-control" value="<?php echo $histoire1 ?>">
          <label for="floatingInput">1ère ligne de la contre étiquette</label>
        </div>
      </div>
      <div class="col-4">
        <div class="form-floating">
          <input type="text" name="histoire2" class="form-control" id="input_histoire2" value="<?php echo $histoire2 ?>">
          <label for="floatingInput">2ème ligne de la contre étiquette</label>
        </div>
      </div>
      <div class="col-2">
        <button type="sublmit" class="btn btn-outline-primary btn-lg">Voir</button>
      </div>
    </div>
    </form>
    <div class="rounded m-2">
      <?php foreach(scandir('etiquettes/rectos/') as $file): ?>
        <?php if(!is_file('etiquettes/rectos/'.$file)): continue; endif; ?>
        <label>
        <img src="generate/000000000000_<?php echo $file ?>" class="img-thumbnail mt-3" style="height: 225px;"/>
        <input name="recto" type="radio" value="<?php echo $file ?>" />
        </label>
      <?php endforeach; ?>
    </div>
    <hr />
    <div class="rounded m-2 mb-6">
      <?php foreach(scandir('etiquettes/versos/') as $file): ?>
        <?php if(!is_file('etiquettes/versos/'.$file)): continue; endif; ?>
        <label>
        <img src="generate/000000000000_<?php echo $file ?>" class="img-thumbnail mt-1" style="height: 225px;"/>
        <input name="verso" type="radio" value="<?php echo $file ?>" />
        </label>
      <?php endforeach; ?>
    </div>
    <div class="fixed-bottom container p-2 bg-light border rounded-top shadow-sm"><div class="input-group"><input id="input_csv" readonly="readonly" class="form-control font-monospace" style="font-size: .875em !important;" type="text" value="" /> <button id="btn_copier" class="btn btn-outline-primary" type="button" onclick="navigator.clipboard.writeText(document.getElementById('input_csv').value); setTimeout(function() { document.getElementById('btn_copier').innerText = '📋 Copier'; }, 2500); this.innerText='✅ Copié!';">📋 Copier</button></div>
  </div>
  <script>
    var update = function() {
      let recto = "";
      document.querySelectorAll('input[name=recto]').forEach(function(input) {
        if(input.checked) {
          recto = input.value;
        }
      });
      let verso = "";
      document.querySelectorAll('input[name=verso]').forEach(function(input) {
        if(input.checked) {
          verso = input.value;
        }
      });

      document.getElementById('input_csv').value = document.getElementById('input_cuvee').value+";"+document.getElementById('input_histoire1').value+";"+document.getElementById('input_histoire2').value+";"+recto+";"+verso;
    }
    document.querySelectorAll('input').forEach(function(input) {
      if(input.id == 'input_csv') {
        return;
      }
      input.addEventListener('change', function() { update(); });
      input.addEventListener('click', function() { update(); });
      input.addEventListener('keyup', function() { update(); });
    });
      document.getElementById('input_csv').addEventListener('focus', function() { this.select(); });
    update();
  </script>
</body>
</html>
