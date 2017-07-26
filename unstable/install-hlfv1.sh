ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.10.1
docker tag hyperledger/composer-playground:0.10.1 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��xY �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�l4�2|4}°�(�>��+��#[ <q,���7�-���BZ�j�`�ۦ(Z}U��.E�󄵋~�鎬��:����L�'�QZghBK��6�"�� KTӰ۫���av�]��m���jz��)U*�*R�,U*fr�]����/ �&lɮ�]���:uh-U��.�;ZKnX�B�,�L��7X'���Ayx$n�ݧ�V,��M`���R��03[�A�~�}v6��uY�8�E�"��#	��^�`��*k��6�4\Ue��\�jB1�~7�fF��p-ӶLe7�ˇ��35�iڍ3C���J�0C�ґ�D��G]%���l3�Ƙ%��*���<g.���8���W䰁j�����/�s�Lw�j��4��Յ�S+����`��;�<��Gl�l�%挺)�jR����"��fO%bT,Uk)=;����0��dQ׿t��K���D<�/h�6�D����ǥ>��x#j�~+Ċ�o/��p���a������,{��d|�����w�l5���-Pa�s�6��7�?�qx��B\����y����g�E�i�v���R ��� J��i��y��ǤX�?��j���pE��4��{`��W�L3d��#f�Mk�/��?�}<��T���F�����a�����E���m�����7�X����rHDc���G7��Z o����Yf [,�wa&̄/uڷ5Z�B�l� ����<�p�z�8?@˰ж�5��nd�0]o�|LK���ѱ\H�d��֔S���T�6鑈��C��хC��k^��f(]�#�]����+���.�x����	u�mUԱ���ji���;Y��Z3$[JG�\��j&���`a��"8I=��@z��Հk�k4����$5ԾT�,6̏�H^z?'1�3*�J��7抺�(�/n�����&_�k.��8_�sL����Ρ5A���u@����l偖��8p:����em��ч(��uUo_��q!�1�/��u��=�$,L�~}I�-�[��,� ��4>��U�HA�c � ���Q���� |��"�a#��i�e�@�$5S-5�M6.[�nl��;9j~�f� �P�{�G13@#8j�+�d �b<b
��k�}�&�m1�^��V1���
2hƝ�d>�w`��y�8G"3oU�<��}�/i�V����6$_���>������ю6G������\�!�0�M�:4PuX��ч�ml�A����t�A,�3�)什��0'�����?���1�qc�Kʯh�U���W���qz����&���3z���D�^а��}��q��1�74�g��P?ڲB5n��/�������au�2�������l�#��s�@m,�������n����NJ_�_<���l����iS�c����v�����4ײpHk �ǰ�T:W޻�:�����Y%U�V���t�1��|ˮ���� _mc����DVnFL�s���T��J�WW�f�o�N  ��nC�Gd��n7�E� ��&��:�lxs��F��~>����;�Yz+U�\=��
R�V���	�y��xaC4YM��L&Jﱂ�lZpo���P�ë�$*�x�<������s��xKB��I�Ed��@w{h������,,.��dAG�t�V�d���舯�|g]��f�BOr��,bs���v���ȸ��+��l�������a��O���� .��(�L�q!���u���?��V�3��UG�i 2-�R/�hG�	�W��ֹ7̑�){��m��gb�&�s�x���	������?����~3������a���?.L��� l�?k���ޅ:ڃ[��e֏��T��?��z�޴�ށ�`�v�O�� Tm��:���{��$�M�{h;�p���9q��Z�3"��t�����JL���"��U�� (�u�5���������>zL�h�ϫ��)4�ꁐ������� �/�an��7af������/�fV��������*��cD���G8�'��L�8`G�`0�3�ĥ��^}���ޡ؋��Y�1a6̌Jᦖ.t;�G�ݷ?����?/��s�)����������#(�ۥ����
,/�eIL�p��r��F���Qf#��g���}�ל���߈������\��������Z�_����s޹"�<��p]��J��E��+�@)�~�	H��yU�Qȡ9�?���et�qȃ�Q͊���%���Zǰ��]#䊐[�Ƈ�ȭ�n���w�
���K��ֻc�A(�˪SU�cQf|�H��F3Y�IQW�Q�ypm�ш�:���D7�w�2�HW���а��g��^����Ǆi�O��o��:�WHV_���̹���k<j���ƚ���m��0�C���ꅋ�BR*W���YJ<�RQL��>�	 �7���qA�kj;��ML�p
L��=��H���١$���t�,U*b�ZJKU)U%���ԓ�a)W�z��p�/[��}9
��O�H����ٳ�T��{i)Y��4�K��I><ȝIh�1a{�œ2��v��~EJ�ʹ���$ހP.��7�wu6ե),�ϲT�+N�^�|*��T�;��	V3��!l��&^�*@7��;��g�ohn��7E��?��> ����kX�B�?���Ll��o-�������y��WAr��k�`��� �j�P����k 6_o3;G���A���]c�%�4>t���O���o,�[1��b���<^N��{E-�A�����D�7�����}.�[��aXnj��Qas��Z�s��{��Ґ:��xvQX�+�-a �#�D/����Գ%�`D�<��/�!rU���؉[B�t��X��kn\�Ԝ��O����\
���g�c�/p1O�o���>_��8�9�0
�a�X�
(�j�
��+��/J_��U:��d�;�����K!�����6��z���/6�-U=��q@cL�6]��M8��%D-+��9�@�9�ٟ���qn����+��r�òQk.<`�C`Xm@�� �|�zg����Gp]�R�9#�o,��Q�r��_��,�����G��pC�C�Ol������L��2� &_Y���U Bb����E�>�27�b\d�)S��7D�]�Kh��'nnz�&������-:��o�-~���?�pwhcu�?g������_+1O=���Em,���i�O���_���|M�Q����?|���_������֟~����<��i)���	��h��N"k5��eȳ���F"�+2�	���Ǝ l��W��~EMW����7�O�ij*�_�!��t�O���m�ɷ�)*e�a9����׭��F��u�������d5�o�������y;�����?�[��������R��[�z�2�i�����0��~�kX��O=�7���O,ܕ�X]�G���_�q����-������?/�7�-���cX�o5�&J�4h� ���0�i�����=�A�\��|KV �g:���H�j{�rd��
���``<�h1J|'��v����%�sQe��NSf������D���rB���&�qmi"U��k �NCR�� %���L.%V%��^/�r��y*%*��8�%�v�,ݒ^/�6#���xW��R�܁q��<g$�;P.�<�A�fE�&%;�T�^��.�r�]�����n���j�F�+K�s���)�t���{]�e�N�<�v.�U�aT�lbxz)��o;��ۤ}Z�s��e�P��b罞����w�b����9�P�1�j�;�i�$���׏ϓ�=H���GGYi�^���4p�w�d�������i_�	�IU:.$���_����qs����X8����R��d�8��X�X腊��l�Q�Z�W�7��S4��B69�5[)�	�-eS)��@����̺;�#6۽�Tu#ߏߪ'��K�q8.W�$��|���ʵ։| d�fEU�B�4~j�;�J<g����)/����y���D����H�����~;-�X�I��#��XHٸW���[H��d�:��x2�L�׭r�;8��j����R�bR�XA�����݂h�{�f0%2m� �R��o���)��k�z��2!'"��U<�`E?��~�i��� f�o�M#cH�,��Dܭ������2�S|"�okeq�NX^*��}uu��#����W�Ǌk���O�eX�n��-��l��=�G�gF��2�6�E��Q���_��/:}�o`M�`����eYas�s-��˹:Z��tBR�R�\v���mkt2�dlC�&7���I��F�)uZ�L�}��cM�k�4T.�G:�v�ɕŲ�O�G�b�,Ժ�9uY�{)�xՀ��_�ֆGea(d4(���\Vm�:�z�0�j������t����U�`��1
���x��ا��>����]������d����]����c��������Z ��ג�\*��g�ip��?R�������Q[�����2�\ͼ)\�݈��7mS>�E�RF)s�)t%���ӷn=SNtC4�&{p��^:�����������7�v5'����^p���S���� �C�1p`IKm���� ,��X��>�#D�����3�2̡E�'s���e���i���lP��/�a���<L����C�/��Bk�Z3!�Pmtɋ@*Ym�!��-UWIĔ��Q]��^��z�.��5~�9�m?0Iz�����7�u�@Q���@ ����� _E��m\#]1�Bf�!���(�Ԍ	AªF����B��F��7lG'�����3�Ks��ڂ�f�%�ſm�Q��T͹�၏;�VM�A�8��鐗��/	C]nhп�G;�� ��D�
��k��y�k�
P�'���g�jb\9�z����	I�//��L��{��������n��q��=�è��n������n۫'�+�"X-,��	'B� $HHhW ��V�#\����?��x>�̛�8�<��_���W�?��WU&��hǣF��?�D�
���mt8�|p�юA0"�d�@��eM4ń�9�ViT���*AR�6H�*t�շ�74�$ו��OH������B$��&��}���|�Pf���+�d �	�rPN6�m��ؗ�c��&���|��|�Y��Y���_�;���3>\�ؕ���~��k����3��?߻��{7��6?��lg@���&�W��g�6P]�	��[���D1�h��}qpoC;`m7{�g0M:��/�=�r	��iJ��!m4��AjH�u����N��\�-�[�i�VI�Kҗ�g\<�?�C;�^�^7 R��1Q\S��� �Ӄ�F�����e��u�࢖�1���� ��-�9�"��d���zJyîmL��[���ҹ)�{B�1���sg8:��|>��9���e�6�W�)�}X*2M�dڵ�HU{}��`M��l�6�-��1D�A����	��>5�A[�X!%���\���d�J�:QT��i�˒��ˆ2�a�kk>?\���뚉�����l�tۡsc���H�d�OX��nU|�����+����sH���S���/��ĵ�|+	�]��$O�7��5�<������nt�5����Ue=�y �ם�u�����"���2J}}��+�{����o�~+����~�Ǉ?��9a�����O���>��>����"~�"~�"į����o���
��vd�3)4��/�^"#G%%ދ�J"����q�K�2�t<ދ�TR� ���ۉD<#'a���S�rZ�vC��'��W�'�w����ό����������2C�!�	�z$��o���f��>}��m�����~��
����������Ճп<�Ӄ�ÿ��v�� c5S�`���J?�n�[z1SP�Y�fX��Q����R��X��Y"�q[����" ���t��}��X�u�p@XsAlG�)���Vrvd^^�Q�=�j	�`��I��i�P��%]t@hm�֏E�.؜�4���l�5w���4��B�m�h���ٔ�W�b_���hy&�v��Gܜ����K��x�E�R�9mG3�P����iX����ڍ�v��U��+m�M�>�<*.��\:�Ka��$,[<o��#ji��|�릮Xt�R�����D���\y֠�홒�7��0�垐��,�f=R�k�0CþW�C�Nc�X�G��y�ɡ��ژXt��6��gKz�Qg�8ǫ55,�<erj!jqS�>�C�SL�}#����cQj����<�	Sd�e����br֛g��*X�<���}��LN��q<k�]��<*M�,�?ѻ�D�Z��U��4=KI�2��#~��Q�	�c�^-�_P��߽V���$$�
�$$�
�$$�
�$$�
�$$�
�$�a.�P�]��F����B�⏯U���ξ�v�ىH�3�ْJ�˝�^ώ�N�����F�\h����@��.��@�B�}k�C �s;ד�� �nމH�۹��?'�޲���"�|�8�͙hi�C�c����f�l��r��i�Y��fT8)��9�Z|2�k�x�n�r�z2����6@/QK^�~�����Iu����3� 2M�<[�T��/T }���nJ�v�_;�/u?%�0�g*1�r��B�	5aWL��ڹQ��f�E"f�Tb���R���z�0�*\�rt�%��feҭr�ǂޠ��g�䐻B�vݽY{����o�~i��У�N�-��;����vs��_0���9��޲�e�7�}A<�:�h��UC׺�Ч�wv�����>
�ta��M��tك�o�u
�v`]��zͯ�e�B?z�j��B��(��o��\�������<�΃���Q�]k�JKh�d������UDSc�LkQ�R�����^��@|�>?����g��zߵs�aa9;�T[.�6Q� ��g���D�A�E8��fs�k�lk��Lӳ�d|�
�B��H���u�Ϭ��06�d�b��(Ԙ%�+���l��ώ�J�Fd��xkv$g�T�2��R���#Վv��&��PR��8o[�N�6ӽ��d�+�?.T�&ND��X�4���-��g�t؝6��9��f�j0`D�BX�� �jMc����Pc谪��^~?{��JY o�C4_��\��h�=X�GĚ�T��e8Z��e1���%J�7��c*"*'���#5���5s8h�]!� U�qĬ�=*�gFJ?�+��٨��ϊ�p��Fx��S��U��ޯ]�4Y(K~�\k�<�քi�ĥKS��������S`x���6�ܒ>�dvX�{��𵊉��"���|�-��`Q���;i��f�q%O݉�껧�����[=��RK���7s�Dp
�,Ɩg�ej�\՚�@����v����[�J����Zs����'�zI�:v}��Ppru^��(�e��N�N6�����[\�B��ʜ(g���e9c�5�7h�5�	C�U㼚+�g�ޛ�Z��#8��*e����������k|����{��*�αR,�bSs�FjV$�X����#p�y�.B�QY1���A���\��uG���>5(F�HT��F���={�����Չ���b�H��lX�N��T�2LIp!*�%��:��Ӯ#���Q'n�#�m�L��.�x΄X��W: �c�3��p�s(Dp�{�CiG�Z�{��I�Q�j�Ho�̄�Gc.kҽV4=������:�i���c��rRo6��~>�/�әF���	�(�u(��Q�8�T���c�L�|���B�͑]S��p���?S��.;! .���;&�/i�4C��b�&ͧTB>n��>9�̫�lH��hB���>�a2Z3�1oG�`(���[�e�Åٸ�;�n+Ө�z��J���4�
}�>�1�n .}7�N0tf�ߛg������1�G�;��}�9�(�n�M⍨����2���U�iM4��Yh�'��Ђ�22���+��Coo��n�${���2�R	=��C���_R~�%�ao%�G=i<�<�8("@����̓&|�ψ������Xq?_N�����F*��$�QhO�&�o�S�1oX����o9�,������|r�x��Z�'�i*f(�%>t�O����P�K�"/M:7�	_*;�k�_n����?�'��7����5��"�؅�������^��~��}��?�|һi����d�^O��N�!ݼS�LR����d���0�t�a2fLr&`�X�PY�DHo��
��:*�e�˻;� \`�4�����k���U�|�;��g��AU�k� �t=/����j��xͺ����֋,�)�/�r�,�r���[���@mM���+z_���@����q1�u E.��A�0�I�`�|t�S���q?Qp�.��� ��j�{P���b�p�8Ȁ����	�Erjz�њ���tB��E�}c���H�>5
�\~�~y��K�Z���/��+��V��I 	g���}�E%>&���.�a�\��N�%���!�ac�S����;Stc�A����<k�}T� 7�E��Ԁ�") ~`5�y�g��,�OV�x�Vl���B���Ms��6�B�Ǝ��auH�m
~�W�!5�Cs��^:��T`
cʅ�^tO�[V'ڨ���~H��ѹe�Xu�J���Nd_nݑ�q���ʦ�7�7�{��厉Fݾ1A�6,���Gk���������_o�A��'��db�&>�Y�_�1>�z:r�?4��bS1zu�1r�+^^��v�x#1��K8�B#�P��7A|�[� l�p8U!)љ���q���Wʫm@��g�7"������|��#8ٌ	f�.0li�-YE���U�u?�Ɖ�|C�~�Q��$Z9p`�^]AZ
��e�a�g@ӝ�0��C�{ӻ7 �p`�nN	��)۟o�ýl��U/c��Z�S_0D(Olt`2���n0���ᡶ����b>��C2j�sG�$(�YC77��CXe|��5��+�ǚGsRp�1�C0׆�� ۱2¦ �l��ظ����!G������vT,����Yy�˕:�ް�u�"[�L4��fɫ*�*v�2qn�d��L��`��8�B[6�7��������	:�ۂ��1�^���|�D�D�*M����j;�V���H���G�D���Jf&� �Xa]3��4��<�{ +���Q�f�Q�"r�M��Ct;4��&^Yf����m:�a&���,Eps�yU4��E�Z�8FSv'���|"�����u7�7f)�mL��X��_�q�p?�j\8�W��3D�m3����`[o��j����.މsm���O�����o�����__��8V�O��Z׉J�ܹ��J|���M�JCԁ�j�u�f�|�4K���1�������[26��1WG��4d�����W�B��r|���������g��5q�+D�2��I)
��He�
HĔX��L��]�Gɩ@T���3QY�I�L��iD���8������=tŊs�
Ns/�ai�|�%?ݬ��Oa�j*�4�ƭ��!���e�b,���	 IR$���d SQ%ލ�  ��g�T$�L+1 ��	��Lg�xJ�@(P0�Sɹ ����S�S,�܆J@\��<wA��q�������(�mC�m����^��[o�To+u���a���\�.��*�w̕�Ɋ4U/'�"W�Y��5�"8��\J��m���^쿆t�~yk��lY��QY�$4�<�,�@v5���B���[��++���pNv*����1�ª�V���V5�?��`��Y�Z�Q�E�Ѥљ9n��ؾ8N=q����wQTx�@D�Xꦄ`�ۗH��+�S.�� �t�g+u��<_ΟV9��1���l����
��t���f~��X8��l��gӑ6?��h�ux&��t�Wfp�✨�S8$�\@
�z�v�8���f��J�f-Tb�R����2'�*�#�G��}�녮鎳&y��:ܫ�X��4�¾��:�c�0oC�E����"���Y݆�2W�g+�l��_���9m�پ�W�w�4���4$Bz9�	1O������ر㭝���)BLЖ�^ݻ{�������=S�$���O��/;���}�z׶����y����_��ȱ�ܱ=�_n�����z�����-߿��?������{�2��+�?���(^��(������lۗ?{�%.l�tw�߯��s��;��Β_n��w�>Ҕ�N��χ�]�Ry_�E�^�ٯ�����90� ��_hR�x�q�E��x���>�w>�����'I��?
����!跬?C�4�?
`���Q���$����?��<���  ����4�?���4E>����?���*�����'E_�OT����_���[��w$ ������j?S�#�K�B�qw���CT�/�$��bR$G�Qg�`)2
FƑJ�H�1/��	N`�「b�������������n���B�o���1��<�3��e6Y��nyW��^w�)�L/����k1�a����?M��+e���G=H�H����eb���=��ۍ��N��p�w���O�C8S[�>�n�^g;���CJ�~�O��x]�k?���g������������'�>P��[��� ����i�N���GT����������?�������
��K�vї�S���p������$�������B ���?��������� ^���/T��*��Y�'K�7�O����N��	s:���w�Gݩ���$�@��>����ϭ������0��- 8��u��IQ���K�}���ŗ�O��Ƣ薲y]��\:us���TH�gh*�������xO���5¬�o����~o������XV��o��|j�$f6M�CEg��d�������q�YNu����f�N�)�Ɔ����<��J�n�;��, ƧJ��;�&��Վ˟�ȍ���>��>�_�����|#�zR�3}ו7�fAxu.�X~o�ձ9\�F����aߧz�N�sw�)C_Ǒ8H�;�&M�ߖ�5��Q�O��.Q��`������u��R�����l�0�qW'�)�R���%��p�_0��QH��?��Â����0�����X��w��(������O���O���w��0��$���� ����X��ý�=�s��(��������//��w���5����>f�{>i�����W��}���?�����M��a=���~�]s�BI���q�Q�f�	2{�YA�\E�M���Z�B���MC1��RO�&.7�>?b[Ce��Щ.;�e�zz����X6����=�)�y�!��*��+��c|��������vlc,7�	];�D����~Z���2�V�r8��Ca�X�b��Y%y"����wG��*JO<���I����42$��qҪg������_������?
�
`��f�1�V��� ����8�?��^����?����(��p�QQH�Tĉ\���IR�1���b2<��BH3AH2!r��dL�_����4������5����j�+e�'�U*�'�^�R���i�l���>��ۢ9�=��}��q��7ܣ��Q�J�Mo;��>\�Ƌ%��VВ4�'��6�d���`]N���햝��G5��-p�����8��gs8�-8���,��
��������/�'��_q����β����~"$��:#^^K�;kn�p9��i�9q��=�z��[zOM���[ǔ�Kk�^��SyL�rg���c�YBv����+��9��<Wj�]���9��a�o�2�`���� �{-���i������'�����O �_��U�������� �����h�"�����w�����%����/����6�����y�(}��7��Ѵ���=��W���8���{f ��1��V�ޝp��a�7��]�J\� �8@����qr���VL�Z�3r�mGD�T)+�zn4+˩�h��z
�RbuzM�1���$pV���z�%����T���b�xaN$�}G���ǯp���~_�2�v+Jn*�x`�$zE9�OB��b`@���Z9IڱU��-�S����iA$�(Z��R�u��&�=6��ZY*so`����V	e����I�l�j����֕���P)���2�G��\+~����u:m5�2��r�Zݣ���<[����6f_̓�bQ��q֭76#�F����,�?���?���_�X����������p���s���H�����[���_���� ������/��������D�Q��Ɋ��E�lH����<�J�@��3~]�A�MG��BL��Cc����N�/'�����_��f'c�r�����7	�^OV���ck�cO�e�+�����։�>:Ή����Q��ݦ&�Ky�X.���,���E���n-��O�.;W<}�wv5�ui��ߪ�U���,*P��Z��S��?��A������C���#�X�7��y���?
`���M������b�8���h������!r��/?���1*��U�wZ��
���~9�կ��֮��Y�cTV���@����ܾ��O��k��T���֘xO���5�=�ߗ�l⧵�y޷����s���j�#^������A�����t�ު���d��O����D�ӭ+�es��	�;��Q�#g2�L��u���#��;����j�7�ݮ�4e�J\�r����������b��;A1��v����جN~��%�
oN�:Wc}w[��Ȧ��i��	UO6Aw�����T/���\�,�nޓ�jTN����jaՏѪ��׾n�$�b�3km��UV���vd�˲��wV{0�� ��0�W@�����^v�-h�
�q����o��?$��o����o��������y
) ,����8�?������ � �����/�A����������Ş����&A���������K�����@��o����� ��I�6�g��Q ��/��m�h ����0��(��`Q0������N��$�����@ ����ܝ�/P��x�?�C�*��U��� �������w�G����0��R  ������n�?��#�����C�����$ �� ������?0�(�n�����a����5�����?0����� ��� ����w��?"�/�$P�_ ������7�����X�?��#�?����������C�w�G���?�@���c���1�� ��ϭ�p��ٽ ��'�����X��
"C�#Q�G!����L�P/F>�y"�)Q�|_�Y��M?��{��3<�A�&�ow��9���>|����s�)�,U�d�_r�����7�Jc5)K�Y�^K�5��j>��+Z�:{I���Re��ݫ��Z����N_J��P�R'ۛ�G����<��^��Nu�_��ծۢc����M��%�E��㕩~�n�T�3����gq(x���p�[(p��!�+X�?�����s�9��E_�O����;�vȘܡ���y��l�����jmڎN���oV��!;�k}�?��x�9;gn��l�ԥ�۱M�;��$a�־���P16ew�S�m�zׇ��ioL��b�u9�I�a��r����k���3�򿈀�����ۿ���	�������A��A��@���X����^�����%�׺��U��?���1j_��Kg`�ӽ�$��/���w�mw�v��)^�Z��:�x���n��ٺ�K�~&mx֩�AB�(���`ӟ�4
;NcOU�I�';)�o���1���I��Z�q�L�5{b;��o�fu��ڮ�<^���u��K���V��T���VI�r���S�$^lhѾ\+'I;�����"uʶ�X9-C	k�b�Vj�n#�meS�U�&w#i��HS�`0122����C�����N*U�3�!O�3�j)5��AE�l��"I�Wɺ6�J�n��ʣ�6���^�w��j���[���x��/M
�_��h8�E��X���_������?��Q��O��F��~���nP�-P����?KR$�?
���4Iݞ����(���|=��?�������g��!��/����������i��z9�;���f4���.����Q�d���C������C�M;�����9�ֹf5�������xJ�_s~v�'�g�y�<u�J��\R����ŵ��ֶ�ߕ�J>fZ�k��T��RP�ԗ����.���i�D�k��]��Ur���T�iq�َ�����]S�\���U攬IY��uW�q�����~B���vE���+��h�k*�}�Oǹ���J2�/?˚�~J��7w�/ٵ��^�HK쉢*��v7LI�7�S��T']�vRߗk6W���!Զ��g�Z�Y�9�j����D��͉#*T��9;8�(.��e�+ҡ-�;���Z9��H��[���9ɝ�rS��}"=����c��¾䴴yK�{�~O�B�q7�p��h��pd�S�#�bi_1!�_f�P�,M��h
,#�|F���8�(?&C*�����m��Y�A�����OFr��vF{��нh;��?���C��9c�cO���o�ʷj�x�\����->���$�p��]�����x��(�����C�?d�0��1�����q�����_�t���_�F&�[�t�����҅΀�F�M������y屠NϹk��`#ޖ��})�#ޓ�����W����>��ZOy���񺼟�L2�f+'�R���+mV۲��v���×�A���@@p����@&D@Q+�7\��7S�2++/P�^�D8�:k���:{���r��⪏��9=4�5�t]L�捲�b��Ӵu��]��C_���dê9=�\Q��W&���~�a?�θ��	g��X�rر)��I�a"U��X�:��sq����<_��&r܏uf�iݛI>�Ǯ;���1c�����(Fih?t��XG��Y�Zw�ca�n��y�Mn���൦�J!Q]no�hp�{���]Q�G������L�A�O��N�]��XŬD:���+�1S�(W�jK��.XVq�P	�J���Z��Y|�~���������=�����n�EJm{#�X�ƦY>��0��qW�������2����%U-ȷ���Z����~��C�0������w��0�Y ��_Mka��B��?o�����1�_l `:�0Ȋ��p������L��>��>��؟+�,��~{�j	�V7�����������6'_�Z���(���u�Ǻ۱�&
ȇ	"���GB�]��:+�ԩ�O��6�&_��?l�'+�u��B�u��:s�</]�b�/����Z�n�}��,���>g�r^-�Й���`��^�G̥p��L����N-��N�ӳ���7h�"��N��/�X���5���p��t�Bx���`�l|Y�Q���ȷY6n^�}Vߏ�-kM�c��Z�)[b�x�6��L�]���n!7�������U�09�/�l[�7�Y�gH���4���x�ʐ9(W1��Uw���8#�a����J�\�G�ԽS	Ú��ǈߧ�U��#�7�eA��������L�E�����?��+���O�!K��D����m�'C@�w&��O����O�����o��?׀�@!��c�"�?��燌���
�B��7�o�n������o���o����-����_y�%����������?����w������M�?��?���'��3A^����}� �������o�?`����'��/D� ��ϝ��;����Y� ��9!+��s������� ����(�����B�G&�S�AQH������_!��r�� ���!������C�����	������`��_��|!������
��0��
����
���?$���� ������!���;�0��	���cA�΀����_!����� �_�����y��?���������\B�a4���<���8��60 ���?��+�W�������&p���*��T�F���a���.�J�2�j�:I릩��dEXc*4FS�÷����(�W����������7�'IXTj
�k�/5XK`�\[�N;i�&k��Ͽ���'a�����M�]�>�+X];��9�Z��~�`jj�p��?���m���M��Gm��v���e�����]X�K�5�፥Bb��
7�PZ{��Y�Ѹ�I�2����ZU�<�����|��nn*�/�����g~ȫ��60�[����/?��!�'?����|J���[�qQ���/?|���S�6!��A���3Cb�Y�k�L�em�]��G�jo͇���)L��e�;Z��l�Nt]|6r)�#	q��æR�=�iTtt�4�KE�Dju���r�R���$�R`�->T����ע��sB����>���ب#"��r�A��A������i�4`�(�����W�A�e�/��=��G���XQ ���Ufy�H7d�N�����>^b�����ښ�Lr��ېףm,&�\{;��)���Et�ۍ�v�j�eW�fe���iyf���	1s���[��H��0s{ML��F]�����հyz��\iun�fɋ:����_��l���Y����k��D��ן��9��Ǎ�{���Zpt)"��D����mA��������C^i>9�|"�,Ξ�gx8ޗt�}0k�Juk�m]�>g�֑[��H�Y���alr_L���c�NHM�i:���vG�t~x��E�8�Oy���� ٣�������v��QaR�O��x{���;�_�Ȍ�_^����>! �����v��)�����Z�w<8����s��N���d�����"�y��#��?w�'��@�o&(��d�Ȋ����c���d��G�|\B��w�A�e���� �+ �l�W���rCa���������_�?2��?�i�����C����(t�7=uf0���~S�������c��R�Sϵia�m����ڏ�Ð�R���~ _Q�;ks�k�o�Z�{�@���_q�a�ϝq���i�V�u�g��>R�{���\�\��u1Y�7ʎ��N��i�w5C})������<sE�rd_��e�ȷ��^�~�;u��&�]�cQ�aǦT�'e��Ti�ce�x����֞��|}f����_֙�uo&i�����Fƌ!׳.��,���~�Ǳ�4��������~��Q�������kM�B������$3��q
��`�?7��^-�w[<" �l�W�����P$�~	� �����/��3������W��?	�?9!w��q��!��c�B�?������#` �Q����s×��z=�������fÎؑ�IՉұF��������>�ǒu��tw�����Z��G5 ��j ��p'����yM���U���(�le1�ö��;��Ҙ��QD��*^?i�p`�+%t�ب�qw��UM�Z��k ����  i�� b6��5mn�vM��>.��z�ZچD{
��1��(�bX;x�V����Qa��Hñ҈ܡ؃*�V:j�!ah4]����Ě���a�7������e���߇E��n�������������c�?�����j�1MZ��ZU5�L#L
�hR�)�$�Z3(\71��L�����Z�!�4�>|��"����?!�?|��?Ĝ:�W�Z�Ϝ����GxG�W��0�-]�\��<�����ʧ�@�����*����h��֛"�)9�}�����a���C�W�qO���$�����g�i,�����G3X��kQ���?�C���T���(B��_~(�C�Onȝ�_L�����!Q���/?|��ϟ�7S{%j=I��%���5�NW\�vZ��!�s��b'���=�O�n<�����fk����VsJ!~t
j�U&�� F������J+�#�J�Nz>@{�m��x���G�}-�����Q������{���� p�(D�������/����/�����h�|P�GQ�9�K�o��?����Z���S��3Q�����x�y7)�{��R�=�߷�  ׅ ^� ��V�W7�T�_��/+fv���^���-�ZO�SY�}��2щ���`d���R���3����*Z�.ʝ]�۬xn}�T�!���T6n�_t�|�r3�s\�`�tL0���X��6�y� r�`��y"�~�7�jU򢱦T���#�5��(��4%��#����O�b+���z1S6�C}*��r�þ�G��|f�x�i�Z�����%�g&�ٳ��c�����92��lu�B�>Z�z-j�����Pl��XX��xN�ʼ�����{G[m�l�O�����/�?F&���'H�B�g�Kwn^)�gjd�޽t�<}��?�T7aԣ����r�ϋ��;j��soZG.�E��t��`k:�Ŀ�r�� %:a��v����l�u�����u����;�����z��������_6���O�_6&�����\/]w�l)������?}J"�y�Sh������Nџ?������������㡚��pt���+�NF%#���K~�xQI�l�'�U�e���FTzg��H���"�(�� 0�#�N`��68!uy��O?���/K��Ou����;l�v�^�_��~����?���ϒ/�W�Y�����ෟ><��LH!}�/J��ۃ�O�y:���r{��޽_z�L�3V��1�A�q�`c,-#(]�R�-=?!�a��������Rl'��=���&���C;�����(}J��;��m�;���5H?�ۻ��b��������	7�������.$y��^h�r��5z�7� {��:P�|=��_N�n[����QXB���k�ܨ�����+��#��b�����%%-��&�>��w�O����=A�o{|�#��sGusi�>L����矔��W5�*��w���ҕ���'���!�    �v�� � 