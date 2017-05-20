(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

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

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

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

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� Վ Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/�����}�s:�n�O��/�i� h�<^Q�D^���QA���/�c��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�8Yɿ�Y���T��%I���P�wo{�{�l�\�Z��r�K���l��+�r�S�U�/��5��N�;�����q0Ew�~z-�=�h. (JӠ����<��8^���k��P|������E0��pʦ\�Fi�Fi�uH��=�-ֶ�����4E2�k;E�Ū�	�&���W��(C���O/��p����,򥆔1 ���:��Zy�j=]6�!�ڢu�����Me�w٤�0	���
V�ׂ���ikA�*̄Բ�O�4q��W��B���f<�-�x�X��I�	ܑ�㹉�S�z�B4�Y��|��,=�N�R7��@��4}������@�e����E/�P׾}�N�U᥯�w�o�_Z��M��������èj��|���*��o�?z��W�?J��S�O���/�?/�,�|�6o5�,�M���A.s �5e)�ɬ�m�!ǳ�Rܶ���\�&�Y��i�q��e9�k�`jZC�[�� J� �D�S�&e�p�u#2�q�pک��)� �6�8�C֐��#u�D]���Ev����A܉�q�jr@1�&��Z=7rw
G� �qEPr�x=X�b�#���2y���rK;
��{0Qx�Tv����Ρ��Չ�XD���Cq'���\��Y�M��I[,���ā�q�t1�Ӹb>��Cso୥bpc�S��L� O
��
p�����yxsh���H"S�n$L�^�[\c�ƨ��s��/;hS@�N��䒡ʅ�ʻ�R�L�ŭ�L�f�E�F�S q������k�Q���Nc��#/�����V�xn,)@�@�����u���(��EƤ����7+&@fK��(�t isy�1����R��(y��@����u��@.|[$�%���1�e�����}v�7��k�r�-'iKj����Ŭ��,��Ez ǢϙE/�f�\�}X|`6<����,����i����x�����������*��O�CI���2���������u�����Nݯv�zK qO��|h��x,fȑ8N�
��Q/!T�G��vB>$��N=��"��U�TA������^���e�$��h�``a���x6ad1Ok�K��w��Dѭ\������5$B}ٚ8����������B�w�<v]�+�<s�y;h��}?���{o��]~�-C��e[�*�ቪ{@k�(̶p-�#��4M93rր�6�����C�� �v~�Ɍ�\�A����}� ����堛��>�u�^��[��kSR�G�D������:��u�Ő�`f����d_��8�#�f5�7�~�&��� 7ؽߤی�	��97�~&׵d:\M�6��C%�u���|����]����'I���("��9�_���#4�W�_*����+��ϵ~A��9&�r�'P�������?3����JA�S�����'}�p�/�l��:N�l��a��a���]sY��(?pQ2@1g=ҫ��.�!�W����P$V�e������qG��V�4��e��,��h\�o����b��Z6�`۶�17�ij��ɗ޲���f�V_r̹�4p�N�#ڃ967�hk�� ����V��(A��f)�Ӱ��y/~i�f�O�_
>J���Е�/��_��W��U������S�)� �?*������+o�����o�Px$t�0�7[� -x�������]=t�0�ޭ���31��B�v�d�� *��< }d�ex�I&��T�[ӹg�6|�=̝�*"��"	s=����z���dް��1�?M�B�x������NV�;�g���5�H��q9#�����@~���-�A�X%�S�q�s ��l(bK Ӑ���s'������m�2	\X�7h�y��磅iϞL�P���I`*����;����C���b��v�in��:K{��,�;�!/7;��
�(!�D��|$s�"yY��	���@N�b�Ak����S���������2�!�������KA��W����������k�;����"X������B�/�b������T�_���.���(��@Т�����%��16���ӏ:��O8C������빁���(���H��>��,IRv�����_���$Y�e���?�	�"�Z�T��csbkL�6��s�U�����Г��b�J }'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߻�x�ǩ���b���j���A��ߙ��?T���\(��ח)��叓H��K�{���������r��8NW�/)����^,Ő��o)��0}~���������F���g1"`1Ǳm�el��P��%X�=,�h��]�� g	&�f�G����P��/����c��j���q��O���>H-�j7���X&��\=V�k��������Հ&\xٮ��sX]W|.E�T�;��ͣ�L8�u>ʼf$���-�?����!�V�g"�	���� ����֫��w�#��K�A�a�t�������;&{}b�Q��o�����������h�
e���b���4��@���J�k�_�c������9+9�Vᯱ�% ��7�g��ǳ���,	���c�ㆹ�T��bxT�޺��p#s�%�~s��(4t���y��]k?�ڹg�@������)�b^|��ж�1���t�o�0��"F�E7Ӭ����	5��D�Xo�Ql�f:Gm᭸h.)�74L��(g=�@�p[�G1��#�|FzxH��9|�tH,̹����p�wk�ʹ�Q�hMX���UjS����ҝJ���9�[a��5� �RgD��ކ��t�w��n�5���`��Ԝ��]]q��B[��n;i�圳�xJX9[��1�C�y��L;AO�%�����ӻ�����E�/��4����>R��t��� ��_~���+��o����Vn�o�2�������'qT	��_�v���c��_��n�$��T�wxv�#�����2?yf(?��G�tw��@�O΁@�q[z-PS �]��'n����I>�AB���Nu7%�},mQI�����z�6�}�VzjJ���[3�c�҄�!��fL�9M���Tnx@A����㤯&���A@OB�=��܇.���� ��Y>h��@�Dk�<�w�u7��+e0��j.uq�?%s9��V{f��!Wk����=h�t�0B��G�P��a�?������/�����Gh���+���O>��������X����?e��]��Te���j����������7��we�����0����rp��/��.��B�*��T�_���.���?�|�����Rp9�a�4��$J1E����>�Q$�8�N�8��(��S��庘�0^e���P��_��~�������������PZ�d��a�2�f�����9��6ض��"o䑶hQ����hN�m�`]	otw�K��#`����;VaDI�1�ַ����0�k�d=�(G��b(���:�b��W��/v�~Z��(�3�z->�?_�h�ڟ�!P����R��Ӭ��_kaAP�۩�g_�Z͵��V�Fv��M���.|/,�c`;�Խr��;����+��F��E2�O���i/#�>ߤV��I��e��7ͮ"~�����W�~���I�����������?�:�7����Z6�]����ޣv�vU�\w+��¯���'�оot�o4�����2�ծ�����ӿI�W��;�6^l"��]×du���oq;�˵=]���Ҏ�Y��7w7�������y�����iu�좹��Q�����:��t�!�@t����\�����x��}E4�]��Q��5���f�y��;x��qf׷_��Yz���vy�Q�=Y��=�x�jkA֟� ʒ;�����M16\G,����^��ǖ�LZ��������q���^����n���nz�k����?��}�z��|�[~�i������;u5���t�x��k��5Ɖ���Y���t=�8ׅ���r{$�{�����&,t rT�ȏ��Y<_�w�Q���?��|8#�Ǟ�����T��n8��H1�]]��@V�� ވ#��!+bw`|c��㶪82��Ӎ���T�5#���j|�,���0O�lo�N7K�lI]g�铽��w�1�[e����Nϥ�SW,��A�Ew��q��@���I�q�;Y��Ǳ�8���w�T@BHEV,B����Q�?@���.j%�|�+��ݢ�����x�I2��NoK���~χ���9�_?�(�[hڇ��x	��欃�M.Wn�-����Cġ<K�St"�!����`�]�5����[�l,%���k�T'Oj ��0ؗ�l�L�]wl����(���j 6�(-�5!��K���ۂ�J8Ąi!�tue�UWE@ppb�k�5]�%���&��R;V&�]
4 X��#vM�q�%b�-#w��uj���T%M��:��43�]��H�b�}�ӹ�D��-�K�,�B�y��VM��=��
�n�̛pu�>��k晛Ӫ��ӈe$�U
���3�:l����E#~��y�-�V�)c�Q5�S3nAݾ9ۋ��)�M�76���-���y8���k39p�����4�����z_��NL�4`u���V����:��]��)�H��^����%<��q�G�sJ�Ӛ�,�Z:�[�T�ͤMX����'�N�>r���.;�`�tFW�a���������-]��̾��e��DM4���U����.s�VWE���PpZr[�a��+9s�1S
�a[����\nB���e��)��7���u�ǳ$���Ֆ� �$3{9�W��ȵ�}����+f�%] ��a��ν"���{j�!��ᓴ
m�f?���u$"��t\�x��!�v�1A+��$f�ioZz��-d�s�~���T��Q�C�^�_�_��:}����[߮�����pnAk�����٧<4�7�"��W������llx�;|��8���7��Y���[��9�^�~�O��օ�K[?�ӧ�w��[%n<��սA��Sa0������`=Ľľ������u�@�	AL�	� 3�D�.��;r��ݗ����|��z��.<���ǟ��[����_0�yV��9���=�#_w#�y�ø8���;߸�d>��5�s����	�ư`nj��nj?�w�%#ݜ��67L�y� .)6/�fb��[��9��:'-�k��y~"��GX���;�-l���>lXH�@�n��n�G��T�+�F�%4Ns��+K1uo?;�R�k�0株
-"���:}��(K��"N��fxv����,Y1I|��ۜm��Di�ȷz�0�
�U�:�!�l�Ov�K�
�ə�*Yp�no���e󣡖k�fʒ�N)�������lU��Z�j�ޑR�7�h8m�R�ث���|1"��~F�hh��oV"A��q�>�˗&�Äu���0a�/����a�c6:��'DX{SOpJt��o�!�����Y�����6�|�K�㯓�d:�K+�]*�_�II��vq.��4.u���@b��ജ����7ZL)4�8�t�Js��Ų��u�0HE��Ot|b
]B�#��S`K�J�b�(=��2�P�6zxU���r�\M��`&k�D��(	��e�Z�5}�P϶S�&��J�(���s�mFA����櫯,�sR�5�.(˞7�[�h��V��AgT0����f��X�����ЉG��5��ΰ)F�r�#��p)����	ĘBU�A{�9����������h)S˲�H�:JfIY�/ȮU���##����4e���)�j�`����j�M�Y��,e���� ����֙t��
m�Z��io ���B]�H�U��*e�P������@Y�xb rF�Մ"N�� �#�0<5�����h�K�jYQ쐥�A��(�����A��תu>�poK(-<Ԕ�t���%1��~\UU��Ǹ�'��
��,G�d�*�E�� !�x�1d��.��`�g�`�E�T��S^����[���R� �m]�RJ1�+5}c9�O�|5��R^_��kq�)��������6��v.�f��p����芺����u'��l!���[w�\A�<�*mg��rqAٷ���F���پs�����NU��;���|W�����"�#w���~O۰EW(]�>eT�!�����}� �Z�T��ɝ���$����ް�j��\U�R���1zF~���6r	\4TE�E���5��XDނ\���<�m��3ϸ��t۝s���&�~o_�en���&��+���r�ȽP��q̕gw�-3=1/3{���A�}\&5�Ť��#?G����G~��`P�#Ȫn~<37r p�I�~68;ƶ?�;�#�O"/�F~�����ay�K��R��K�s'ݓ���l���f��'Ja*T�D�{����ҹ/<h�#%��:��F�A�Zt0V��<�+�M�Ypp�h��.88k�<��f�Dt Nz��SѶ�e(�7fv�ְL�uӈ���8���{F�S�$�`10�4!Z�K���/c�@w�J/B�6�dӆP	4��p�%}�*G&�`�@Xk�0YL�|�����yLN���xh����33*M��A�aУ�^2uO��,�(�\+��:��ŃcB�PK�����J�Q�A=�'�l�q��;��1��Cf���YߣL/b8Ժ�ah�P���ͫ-�K�<�&D�X�p;���c'���C/��mЩ|�sy�􇦎�|��ϴa���E���e��lg8�yg��D˻��'f����8����ˉ��q"i�"���ߪDki��"u!�ś��K
d���G�T�E�&)�̓"�BPdg��Z&A��f�Y�p~<L�\�,C8���9�$�VF�X:Cbr7cz�¸����pF.ƫ��@���i�1��G�j���8��d�IH�xi>r4N9��P��~�~_ �X����n�w �=�a|,�I��]�!�~ig`�\��ޘ`�ú_��ȴ��K�q̃���� ��A��������7:nȩ=�D���hT��B���IO�Y��c�v���r��1��7�8���]��m�yO�-�� ��QHn�0��M����]>�r�#�zO��t+Z����ߞF4�ZMC4`���]��������PR�TxrA�-p)'���y7�G��f���\@��ܛ�fv��#?yy��ޏ�?��_z�����ܟ߃�c��[]ux�Z�ݜ��VNT?�:N��������$��q}�������������}�����������?������O�/%�� ܺ����Z\��]јL'jԐ�����}�~����P���n�G~����?|�^b�_1ȯ稝?s#//R;�P;j�C�thM��v:_q_�_q����v���ӡv:>�㳽����[�F>�S�*7���U�=,rAS|[4���"��2�1����L��1�Gȟ߿��4GMxqx�[���O�ΧT�g��c����3�n��v�^��f���r��8�VgΌ3-���̙q��1��0g��}�0�v�̹q�a�S��6�m����s$s����-p�䟓��$'9�u��
jػ  