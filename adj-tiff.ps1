function Get-Basename($filename) {
   #�t�@�C��������g���q����菜��
   $filename = $filename.Replace(".tif","")

   #�t�@�C��������J�b�R����菜��
   $idx = $filename.LastIndexof("(")
   if ( $idx -ge 1) {
      $filename = $filename.Remove($idx)
   }

   #�g���q�ƃJ�b�R���������t�@�C������߂�l�Ƃ��ĕԂ�
   return $filename
}

function Create-Surveyname($filename) {
   #�����l�ݒ�
   $i = 1
   $basename = "sokuryouzu"
   $ex = ".tif"
   $n = "0" + $i.ToString()
   $svname = $basename + $n + $ex

   #sokuryouzu01���瓯���t�@�C���������݂��Ȃ��Ȃ�܂Ő�����傫������
   while (Test-Path(".\" + $filename + "\" + $svname)) {
      #�J�E���^�[���グ��
      $i++

      #�J�E���^�[��1���������ꍇ��2���ɂȂ�悤�Ƀ[�����߂���
      if ( $i.Length -ne 2 ) {
         $n = "0" + $i.ToString()
      }else{
         $n = $i.ToString()
      }

      #�V�����ԍ��Ŗ��O����蒼��
      $svname = $basename + $n + $ex

   }

   return $svname

}

Get-ChildItem -Name *.tif | Sort-Object | ForEach-Object {
   #�t�@�C��������g���q�ƃJ�b�R����菜��
   $basename = Get-Basename($_)

   #�t�@�C�����̃f�B���N�g�����m�F���đ��݂��Ȃ���΃f�B���N�g�����쐬����
   if ( (Test-Path($basename)) -eq $False) {
      New-Item -Type Directory $basename
   }

   #�V�����t�@�C������ݒ�
   $svname = Create-Surveyname($basename)
   $svname = ".\" + $basename + "\" + $svname

   #TIFF�t�@�C��������̃t�@�C�����ɕύX���Ĉړ�����
   Move-Item $_ $svname

   echo $svname
}