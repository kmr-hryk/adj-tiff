function Get-Basename($filename) {
   #ファイル名から拡張子を取り除く
   $filename = $filename.Replace(".tif","")

   #ファイル名からカッコを取り除く
   $idx = $filename.LastIndexof("(")
   if ( $idx -ge 1) {
      $filename = $filename.Remove($idx)
   }

   #拡張子とカッコを除いたファイル名を戻り値として返す
   return $filename
}

function Create-Surveyname($filename) {
   #初期値設定
   $i = 1
   $basename = "sokuryouzu"
   $ex = ".tif"
   $n = "0" + $i.ToString()
   $svname = $basename + $n + $ex

   #sokuryouzu01から同じファイル名が存在しなくなるまで数字を大きくする
   while (Test-Path(".\" + $filename + "\" + $svname)) {
      #カウンターを上げる
      $i++

      #カウンターが1桁だった場合は2桁になるようにゼロ埋めする
      if ( $i.Length -ne 2 ) {
         $n = "0" + $i.ToString()
      }else{
         $n = $i.ToString()
      }

      #新しい番号で名前を作り直す
      $svname = $basename + $n + $ex

   }

   return $svname

}

Get-ChildItem -Name *.tif | Sort-Object | ForEach-Object {
   #ファイル名から拡張子とカッコを取り除く
   $basename = Get-Basename($_)

   #ファイル名のディレクトリを確認して存在しなければディレクトリを作成する
   if ( (Test-Path($basename)) -eq $False) {
      New-Item -Type Directory $basename
   }

   #新しいファイル名を設定
   $svname = Create-Surveyname($basename)
   $svname = ".\" + $basename + "\" + $svname

   #TIFFファイルを所定のファイル名に変更して移動する
   Move-Item $_ $svname

   echo $svname
}