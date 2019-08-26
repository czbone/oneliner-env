# 1�s�Ŋ��\�z
�T�[�o��`root`���O�C�����P�s�̃R�}���h�����s���邾���Ŋ��\�z�ł���X�N���v�g�ł��B  
�K�v�ȃ\�t�g�E�F�A�����ׂĔ[�܂�A�A�g��������Ă���1��̃T�[�o�������܂��B  
���\�z�͓���A�����ւ񎞊Ԃ�������Ƃ������𑦍��ɉ������܂��B

���̃v���W�F�N�g�́A���m�ɓ��삷�邲���W���I�Ȋ����\�z����̂�ړI�Ƃ��Ă��܂��B
����ȏ�̊����K�v�ȏꍇ�́A�o���������炳��ɓƎ��̃J�X�^�}�C�Y���s���̂��x�^�[�ł��B

## �Ώ�OS
- CentOS 7, Ubuntu18

## ���C�Z���X

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

# ���s���e
���[�J����Ansible���C���X�g�[�����AAnsible Galaxy��Playbook����{�ɏ����J�X�^�}�C�Y���Ċ��\�z���Ă��܂��B
���̓��F������܂��B

- �ŐV�̃\�t�g�E�F�A��
- ���{��œK��

# �g����
�V�K��OS���C���X�g�[�������T�[�o��`root`�Ń��O�C�����A�\�z���������̃X�N���v�g�����s���܂��B
������͈�U�T�[�o���ċN�����Ă��������B

## Web�T�[�o(LEMP)���\�z (���v����: ��10��)
Linux(L),Nginx(N),MariaDB(M),PHP(P)��LEMP�����쐬���܂��B

### �o�[�W����
- Nginx 1.16.0(CentOS), Nginx 1.14.0(Ubuntu)
- PHP 7.3
- MariaDB 10.3.15

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp.sh | bash
```
## ����z�M�T�[�o(LEMP+FFmpeg)���\�z (���v����: ��1����)
LEMP���쐬��A�K�v�ȃ��C�u�������W�߂čŐV��FFmpeg�̃r���h�������s���܂��BFFmpeg�̃r���h�ɂ͎��Ԃ�������܂��B

Nginx�͍ŐV�\�[�X��RTMP���W���[����ǉ����ăr���h���Ă��܂��B
FFmpeg�̓R�[�f�b�N��AV1��h265���ɑΉ����Ă��܂��B���̑���FFmpeg�̐ݒ��[������](https://github.com/czbone/oneliner-env/blob/master/ffmpeg_spec.txt )���Q�Ƃ��Ă��������B

### �o�[�W����
- Nginx 1.17.3
- PHP 7.3.8
- MariaDB 10.3.17
- FFmpeg 4.2

```
$ curl https://raw.githubusercontent.com/czbone/oneliner-env/master/script/build_lemp_ffmpeg.sh | bash
```

# ����`�F�b�N

���\�z��AWeb�u���E�U��URL�ɃA�N�Z�X���A�ȒP�ɓ���`�F�b�N���s���܂��B�ulocalhost�v�����͊��ɍ��킹�ĕύX���Ă��������B

phpinfo���\������܂��B
```
http://localhost/index.php
```

�e�X�g�pDB�ɓ��{�ꕶ�����o�^���ĕ\�������܂��B�������������ɓ��{�ꂪ�\������Ă����OK�ł��B
```
http://localhost/index2.php
```

# ���؊�
- **Vagrant Box** CentOS7�ucentos/7�v, Ubuntu18�uubuntu/bionic64�v
- **������VPS** �uCentOS7�v(�W��OS), �uUbuntu18.04 amd64�v(�J�X�^��OS)
