// nnedi3-nns16-win8x4
// 移植自 https://github.com/bjin/mpv-prescalers/blob/master/compute/nnedi3-nns16-win8x4.hook
// 有半像素的偏移

//!MAGPIE EFFECT
//!VERSION 2
//!OUTPUT_WIDTH INPUT_WIDTH * 2
//!OUTPUT_HEIGHT INPUT_HEIGHT * 2


//!TEXTURE
Texture2D INPUT;

//!SAMPLER
//!FILTER POINT
SamplerState sam;

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT * 2
//!FORMAT R16_FLOAT
Texture2D tex1;

//!COMMON

#define T(x) asfloat(x)
#define W(i,w0,w1,w2,w3) dot(samples[i],float4(T(w0),T(w1),T(w2),T(w3)))
#define WS(w0,w1) sum1 = exp(sum1 * mstd2 + T(w0)); sum2 = sum2 * mstd2 + T(w1); wsum += sum1; vsum += sum1*(sum2/(1.0+abs(sum2)))


//!PASS 1
//!DESC double_y
//!IN INPUT
//!OUT tex1
//!BLOCK_SIZE 32,16
//!NUM_THREADS 32,8


float nnedi3(float4 samples[8]) {
    float sum = 0.0, sumsq = 0.0;
    [unroll]
    for (int i = 0; i < 8; i++) {
        sum += dot(samples[i], 1.0f);
        sumsq += dot(samples[i], samples[i]);
    }

    float mstd0 = sum / 32.0;
    float mstd1 = sumsq / 32.0 - mstd0 * mstd0;
    // 不能使用 lerp，否则结果可能为 nan
    float mstd2 = mstd1 >= 1.192092896e-7 ? rsqrt(mstd1) : 0.0;
    mstd1 *= mstd2;

    float vsum = 0.0, wsum = 0.0, sum1, sum2;

    sum1 = W(0, -1123354974, -1112248839, 1046299686, -1143613552) + W(1, -1118620174, 1024662558, 1028038478, -1129268360) + W(2, 1016130204, -1087068557, 1063313277, -1103342192) + W(3, -1103968288, 1048182784, 1047279381, -1115088511) + W(4, -1101453425, 1059583965, -1088182320, 1003350800) + W(5, -1117908518, -1119323982, 1034186247, -1134684248) + W(6, -1122284590, 1027638054, -1124394588, -1111377363) + W(7, -1122818124, -1137723992, 978245507, 1028117438); sum2 = W(0, -1162931039, -1131063526, 1029801649, -1117642655) + W(1, -1136248556, -1131086728, 1031011705, -1128864654) + W(2, -1115594515, -1128443230, 1042762789, -1107118398) + W(3, -1119907402, 1044675527, 1050674207, -1113986381) + W(4, 1022791334, -1107588397, 1009001220, -1186206458) + W(5, 1017500018, -1111169922, -1112569685, 1017255694) + W(6, -1156766128, -1125594766, -1148613464, 993928432) + W(7, 1014782692, -1135599628, -1114139175, 1007622876); WS(1038828992, 1041685264);
    sum1 = W(0, -1114329248, 1049950910, -1097681183, 1028668144) + W(1, 995958527, 1027336960, -1107326552, 1025858258) + W(2, -1117673776, 1060640651, -1085831405, 1033402064) + W(3, 1034401008, 1045782072, -1105157973, -1122828000) + W(4, 1038612842, -1098159517, 1053136924, -1110558370) + W(5, 1035088196, -1106507532, 1032016120, -1113173980) + W(6, 1008781376, -1124000392, 1023707152, 1012109856) + W(7, 1029875310, -1105439902, 1034119968, -1114749520); sum2 = W(0, 1031315360, -1099468189, -1112139926, 1036663822) + W(1, -1131767489, -1140834082, 1024287080, -1122285462) + W(2, 1023637252, -1100127579, -1117241706, 1038018354) + W(3, -1107869385, 1052854494, 1052996200, -1112496415) + W(4, -1107666272, 1034036134, 1027811452, -1110479054) + W(5, -1117110288, 1024451620, 1027157968, -1112615559) + W(6, -1124350185, 1003450083, -1131082337, 998992195) + W(7, -1110538107, 1041131277, 1035032776, -1106762474); WS(-1086074680, 1053637716);
    sum1 = W(0, -1121345387, 1042002951, -1113042450, -1121398619) + W(1, -1148805338, -1165378922, -1115297518, 991217235) + W(2, -1136570733, 1052460699, -1107443934, -1117268427) + W(3, 1049266593, -1094571489, -1098765182, 1036113926) + W(4, 1027081787, -1124281856, 1043313411, -1136658365) + W(5, -1133439181, 1040734807, 1006695533, -1112513138) + W(6, -1158465386, -1121708851, 1016359031, 1021173351) + W(7, -1120818857, 1035650578, 1027853163, -1106476275); sum2 = W(0, 1026517575, -1170492850, -1138816415, -1143472678) + W(1, 1017334370, 1003954710, -1132363566, 998846550) + W(2, 1051558711, -1096673587, -1136175651, -1124275402) + W(3, 1071692777, -1077357700, -1098960792, 1018703670) + W(4, 1049822619, -1098179385, -1116986501, 1007812651) + W(5, 1020207734, 996694924, 1003290486, 1007766851) + W(6, 1022251878, -1122577241, -1141894102, 1009415395) + W(7, 1019995718, 1015494226, -1126828734, -1163222937); WS(1051521136, 1027207116);
    sum1 = W(0, -1122694020, 1010830545, -1124291704, 1018062184) + W(1, -1121133108, -1124202632, 1037913146, -1116091286) + W(2, -1102175837, 1057246783, -1093542759, 1041281977) + W(3, -1116351908, 1026322980, 982577970, -1125394504) + W(4, 1045518980, -1089509425, 1055793637, 1008755233) + W(5, 1009393969, 1025178484, -1118947636, -1127575032) + W(6, 1008379217, -1117338572, 1001093793, 1015898776) + W(7, 1015772516, 1009646833, 1001810977, -1121163492); sum2 = W(0, -1137495011, -1135527491, 1027730022, -1118108263) + W(1, 1013616911, -1123650952, 1024465134, -1128775579) + W(2, -1135578111, 1013443151, 1049128967, -1098008683) + W(3, 1029346938, -1114797945, 1068130737, -1080443718) + W(4, 1017473747, -1122100892, 1046423571, -1101482344) + W(5, 1012413655, -1128721387, -1143058109, -1137148015) + W(6, -1133405571, -1166794345, 1020545683, -1128178767) + W(7, 1008139351, -1156685818, -1126785325, 991435034); WS(1057767608, -1132080751);
    sum1 = W(0, 1026028453, 1025766741, 1035118319, 1012106581) + W(1, 1026017621, -1135552917, 1040474693, -1138611630) + W(2, -1117947285, 1051769667, -1111744027, 1030333189) + W(3, 1048679017, -1083959172, -1084413328, 1045191121) + W(4, 1025261389, -1120826122, 1049618505, -1122181545) + W(5, 1011196341, 1045191525, -1110336171, 1030480605) + W(6, 1015828970, 1028389741, 1028257397, 1027514349) + W(7, 1025013027, 1039505775, -1123719333, 1020294666); sum2 = W(0, 1017587161, -1101123140, 1040188371, 988296658) + W(1, 1028118553, -1103020887, 1022642341, 1010063898) + W(2, 1008167722, -1099714612, 1039093756, 1026403646) + W(3, 1005112948, 1049070164, 1046164698, 1033545355) + W(4, -1125344655, 1032013714, -1111525569, 1002132020) + W(5, 1015776789, 1022049457, -1098832696, 1037334715) + W(6, -1148301500, 1009340114, -1115917000, -1139728254) + W(7, -1138850406, -1167693540, -1103378287, 1035581889); WS(-1099372256, -1088618788);
    sum1 = W(0, -1112538182, 1048693927, -1112344546, -1109099742) + W(1, -1113349022, 1033711782, -1129092599, -1110127398) + W(2, -1103996671, 1064716592, -1086749016, 1032699126) + W(3, 1024020908, -1143605597, 1044926535, -1121424940) + W(4, 1046614908, -1085173359, 1062252083, -1130166943) + W(5, -1111225386, 1004694493, 1040479887, -1106709441) + W(6, -1110537326, -1108087402, 1034104622, -1120726228) + W(7, -1114146165, -1138402062, 1042110371, -1106064827); sum2 = W(0, 987083788, 1013472954, -1120418118, 979955865) + W(1, -1144106823, -1131186779, -1122269098, -1163904780) + W(2, -1120467381, -1139561796, 1038342084, -1115615181) + W(3, -1121977305, 1044091298, 1042996066, -1127292875) + W(4, -1118651341, 1038343490, -1118476220, -1123141745) + W(5, -1162389292, -1115306287, -1128689408, 1014320394) + W(6, -1152635694, -1155962630, -1132569906, -1135582470) + W(7, 964510307, -1117365756, -1141833923, 1008840046); WS(1041282784, 1044242623);
    sum1 = W(0, -1119885764, -1171512555, 1003864029, 1025494836) + W(1, -1119816052, -1121861252, 1040963149, -1113504879) + W(2, -1100880653, 1057266723, -1094412795, 1043843337) + W(3, -1113812594, 1010135439, -1118004569, -1125989575) + W(4, 1046531310, -1089952515, 1056310444, -1156936827) + W(5, 1015358999, 1031135156, -1114099002, -1122714492) + W(6, 1005085853, -1115226950, 1015234855, 1003362397) + W(7, 1021011107, 1003139037, 992693307, -1120612644); sum2 = W(0, 1005317381, -1142619324, -1126266146, 1026462555) + W(1, -1143827754, 1012902153, -1128784654, 1020893616) + W(2, 1019060164, -1114788024, -1094218173, 1054132458) + W(3, 1009279342, -1098688460, -1078812823, 1070492026) + W(4, 1014092605, -1120377499, -1099532818, 1048935725) + W(5, -1131000233, 1017453102, 1007638067, 1011358224) + W(6, 1012779564, -1139793504, -1130333980, 1015734963) + W(7, -1137528453, -1147729078, 1018177647, 987943782); WS(1046635232, 1024078131);
    sum1 = W(0, 1002735212, 1035063871, -1097977761, 1040314319) + W(1, 1025138813, 1034039879, -1105608655, 1035664624) + W(2, 1017042555, 1044122447, -1094991056, 1038536855) + W(3, -1132524982, -1110416695, 1051547730, -1114843703) + W(4, 1031803657, -1092481954, 1050188814, 1003107468) + W(5, 1033606155, -1094320024, 1047410847, 1019470987) + W(6, 1021596219, -1107502027, 1031346589, 1021345835) + W(7, 1015508823, -1103391009, 1046101811, -1136683190); sum2 = W(0, -1096475926, 1044036812, 1052862983, -1106234474) + W(1, -1112281069, -1112231286, 1024115789, -1121785528) + W(2, -1116645717, -1111398905, 1051331710, -1130292776) + W(3, 1041647377, -1096068583, 1038036111, 1037359643) + W(4, -1113263240, 1026411348, 1042458641, -1111704128) + W(5, 1023473494, -1114320784, 1028002558, -1123406807) + W(6, -1117017643, -1138574198, 1037890580, -1109714921) + W(7, 1039764966, -1104710548, -1106844581, 1041123403); WS(-1088554040, -1076674880);
    sum1 = W(0, 1026292820, -1132973070, -1144171612, -1130131975) + W(1, 1016736263, 1034501898, -1110973538, 1028857234) + W(2, 1042339025, -1089525132, 1052671191, -1108906970) + W(3, -1110236986, 1037427962, -1123890785, -1112145786) + W(4, -1103961368, 1056478885, -1092344862, 1002874044) + W(5, 1016313655, -1118983748, 1041641985, 1025897228) + W(6, -1151588920, 1038469390, 1010979982, -1130905399) + W(7, 1014755782, -1123320716, 1017396903, 1033705562); sum2 = W(0, 1013915195, -1133182691, -1127318198, 1020584890) + W(1, 1007730851, 1024414743, -1121307593, 1005058566) + W(2, 981970521, -1111248658, 1035588225, -1124411850) + W(3, 1028189234, 1040952978, 1057294107, 1029625115) + W(4, -1121038101, -1109339192, -1107404728, 1026110889) + W(5, -1142484934, -1094377458, 1024397525, 1023925523) + W(6, -1146368902, -1116592821, -1118541421, -1140327971) + W(7, 1010322539, -1112421528, 1019759378, -1199698720); WS(1063581112, 1015292283);
    sum1 = W(0, -1123806598, -1125096044, 1046804719, -1117498166) + W(1, -1124445804, 1037634467, 1028314614, 1006823135) + W(2, 1036776315, -1083793455, 1064148787, -1106689849) + W(3, -1112186771, -1098422117, 1034155462, 1004978479) + W(4, -1102837698, 1058965073, -1089226130, 1033810693) + W(5, -1117642958, -1106625757, 1037373467, 1029436414) + W(6, -1137018200, 1036181095, 994321759, -1119765454) + W(7, 1010580432, -1127761788, 1021285644, 1034713459); sum2 = W(0, -1127012521, -1110373665, -1121983257, 1021812843) + W(1, -1129458054, -1122115974, -1121551577, 1015201109) + W(2, -1134632819, -1118435057, -1107711610, 1039413537) + W(3, -1113739078, 1041258512, 1043546644, -1127386873) + W(4, -1106078947, 1025961773, 1048226293, -1110385416) + W(5, -1115241196, 1041055451, -1131486243, -1135801459) + W(6, -1122814807, 1025056413, -1139476701, -1132245806) + W(7, -1119046895, 1029845331, 1018415015, -1140149017); WS(-1109010880, -1087548956);
    sum1 = W(0, 1034947768, -1095012676, 1046023882, 1029737824) + W(1, 1034343312, -1102610188, 1039446704, 1025692706) + W(2, 1016751552, -1096454908, 1042564604, 1038373096) + W(3, 1019661856, -1091443170, -1105694067, 1039271048) + W(4, -1126501287, -1131030249, 1044246468, 1012879825) + W(5, 1017025648, 1042942296, -1103700296, 1041317114) + W(6, 1030724160, 1019936112, -1141422594, 1029263800) + W(7, -1140792121, 1024647464, -1107855416, 1041193844); sum2 = W(0, 1034034732, -1107522705, -1105460279, 1021740679) + W(1, -1113997103, -1121503695, 1038975878, -1112744336) + W(2, 1028771217, -1114143244, 1032873918, -1121564954) + W(3, 1025456143, -1105773446, 1059420344, 1024971971) + W(4, 1035315492, -1109746606, 1040681265, -1122379806) + W(5, -1102403849, -1106040358, 1046039582, -1106873869) + W(6, 1018212015, -1106459627, 1026290649, -1130313815) + W(7, -1099438501, 1039219872, 1046943722, -1105420350); WS(-1086299832, -1077288694);
    sum1 = W(0, 1021716686, -1099039878, -1111509136, 1039618828) + W(1, -1132921948, -1108540692, 1021468846, -1131678690) + W(2, -1113901292, -1158126306, -1096197083, 1041516082) + W(3, -1108835908, 1055092577, 1062013047, -1118733319) + W(4, 1023078294, -1089051407, 1050708993, -1122936235) + W(5, 965138311, -1113759276, 1022391342, 1015065790) + W(6, 998651320, -1107695832, -1133490396, 997649137) + W(7, -1130194922, -1113503632, 991635057, 1023538631); sum2 = W(0, -1133976495, 1035891239, -1130801609, -1113698362) + W(1, 1027343155, 1030599513, -1108453664, 1016406968) + W(2, -1149877867, 1037590422, 1012747883, -1108226898) + W(3, -1119506980, 1054189655, -1119322812, -1120928356) + W(4, -1126385541, 1041308688, -1107379808, 1016225738) + W(5, 1016526837, -1112736561, -1119223720, 988482485) + W(6, 994153115, 1004824957, -1116360142, 1018050885) + W(7, -1140785051, -1120347934, -1129452107, -1117792638); WS(-1113279936, 1066223903);
    sum1 = W(0, -1128171420, 1040261344, -1112013315, -1123695998) + W(1, -1141738481, -1140107833, -1116929726, -1154978689) + W(2, -1138940153, 1050703688, -1108200895, -1123177006) + W(3, 1044160156, -1100167260, -1100730273, 1034288823) + W(4, 1020686276, -1130335589, 1040782300, -1141423761) + W(5, -1129655596, 1035637471, 1024316286, -1114187043) + W(6, 964173357, -1124525100, 1014134393, 1013984857) + W(7, -1123239900, 1032644739, 1029624526, -1108229911); sum2 = W(0, -1115606620, 1021458196, 1009639320, -1131253088) + W(1, -1125272644, 1017345212, 1016051020, -1143902384) + W(2, -1099614716, 1047257730, -1120838650, 1020803060) + W(3, -1080575150, 1068148121, -1113655261, 1032085971) + W(4, -1102155153, 1044966894, -1132238288, 1016311348) + W(5, -1122847678, 1026244022, -1130782536, -1137376840) + W(6, -1123394906, 1017049220, 967940860, -1137115752) + W(7, -1129056732, 1010161976, 1004223696, -1136984808); WS(1060545080, -1126581603);
    sum1 = W(0, 1032630360, -1112268976, 1045186906, -1125010622) + W(1, 1037657648, -1128752350, 1032285712, 1029508223) + W(2, 1043836232, -1090205186, 1053340438, -1108078856) + W(3, 1037448680, 1048595306, -1094666759, 1041691860) + W(4, 976149203, 1057651571, -1082657749, 1042698525) + W(5, 1031833596, 1035187792, -1092127852, 1040118132) + W(6, 1031675647, 1034806588, -1104761760, 1033087420) + W(7, 1025282125, 1043419290, -1096441814, 1034587656); sum2 = W(0, -1123698886, 1034075649, 998149095, -1113635181) + W(1, -1126365381, 1026991402, -1118780236, -1168196508) + W(2, -1135914762, 1019253181, 1023543366, -1114469118) + W(3, -1121651762, 1047572688, 1038479879, -1145545780) + W(4, -1118625490, 1035108181, -1114677625, 992781287) + W(5, -1122087574, -1115886918, 1011684618, -1139655050) + W(6, -1147908244, 1016718341, -1132109957, -1142844852) + W(7, -1134045690, -1117034488, -1137057610, 1007905050); WS(-1083899832, -1105526146);
    sum1 = W(0, 1026357515, -1119744955, -1117075907, -1111407198) + W(1, -1139718894, -1125720471, -1106102943, -1152407445) + W(2, 1044187583, -1092285679, 1048719011, -1107209883) + W(3, -1105573131, 1062437883, 1052836221, -1107292779) + W(4, -1104526300, 1058460257, -1089717563, -1122559055) + W(5, -1119529939, 1022150135, -1123085499, -1119739267) + W(6, -1125768375, 1033366698, -1114009838, -1119196243) + W(7, -1132776678, 1009731342, -1112611206, -1129505495); sum2 = W(0, -1110807022, 1025172792, 1033543849, -1123816828) + W(1, -1129400032, -1117035240, 999654946, -1144812946) + W(2, -1105612607, 1035443403, 1039345667, -1120747576) + W(3, -1123619892, -1135427545, 1053020794, -1113498942) + W(4, -1131262448, -1111010692, 1047843748, -1113301822) + W(5, 1016529300, -1115955576, -1135856481, -1146605522) + W(6, -1129444600, -1117326476, 1022819536, -1119691028) + W(7, -1136239801, -1121250556, 998047364, -1135792457); WS(-1107513792, 1064663354);
    sum1 = W(0, 1030862455, -1113532308, 1032378968, -1123071015) + W(1, -1161118946, 1021510766, -1127591630, 1009770420) + W(2, 1040244826, -1091621085, 1051734861, -1107582956) + W(3, -1104300038, 1046262406, 1034822530, -1108820108) + W(4, -1102940181, 1054782000, -1095483267, -1125175670) + W(5, -1135077628, 1019068110, 1031948820, 1025488559) + W(6, -1135539484, 1036941280, -1172984259, -1126076542) + W(7, 1011863892, -1128724830, -1120336759, 1036426604); sum2 = W(0, -1135206239, -1140752647, 1022777359, 974924014) + W(1, -1139065871, -1123380440, 1021581075, -1133276463) + W(2, 1026230428, 988696695, -1122295168, 1029689087) + W(3, 1025917606, -1092786651, -1085937537, -1140169471) + W(4, 1027050280, 1049996339, 1032573953, -1135329695) + W(5, 1013849783, 1057784826, -1130048007, -1124883951) + W(6, 1016077019, 1033822297, 1032545188, 1011238415) + W(7, -1127829351, 1034470972, -1137094527, 1001568686); WS(1058918200, -1121082995);
    return clamp(mstd0 + 5.0 * vsum / wsum * mstd1, 0.0, 1.0);
}

float GetLuma(float3 color) {
    return dot(float3(0.299f, 0.587f, 0.114f), color);
}

groupshared float inp[429];

void Pass1(uint2 blockStart, uint3 threadId) {
	const float2 inputPt = GetInputPt();

    const uint2 group_base = uint2(blockStart.x, blockStart.y >> 1);
    for (int id = threadId.x * MP_NUM_THREADS_Y + threadId.y; id < 429; id += MP_NUM_THREADS_X * MP_NUM_THREADS_Y) {
        uint x = (uint)id / 11, y = (uint)id % 11;
        inp[id] = GetLuma(INPUT.SampleLevel(sam, inputPt * float2(group_base.x + x - 3 + 0.5, group_base.y + y - 1 + 0.5), 0).rgb);
    }

    GroupMemoryBarrierWithGroupSync();

    float4 ret = 0.0;
    float4 ret0 = 0.0;
    float4 samples[8];
    const uint local_pos = threadId.x * 11 + threadId.y;
    [unroll]
    for (int i = 0; i < 8; ++i) {
        [unroll]
        for (int j = 0; j < 4; ++j) {
            samples[i][j] = inp[local_pos + i * 11 + j];
        }
    }

    const uint2 destPos = blockStart + uint2(threadId.x, threadId.y * 2);
    tex1[destPos] = samples[3][1];
    tex1[destPos + uint2(0, 1)] = nnedi3(samples);
}


//!PASS 2
//!DESC double_x
//!IN tex1, INPUT
//!BLOCK_SIZE 64,8
//!NUM_THREADS 32,8

float nnedi3(float4 samples[8]) {
    float sum = 0.0, sumsq = 0.0;
    [unroll]
    for (int i = 0; i < 8; i++) {
        sum += dot(samples[i], 1.0f);
        sumsq += dot(samples[i], samples[i]);
    }

    float mstd0 = sum / 32.0;
    float mstd1 = sumsq / 32.0 - mstd0 * mstd0;
    // 不能使用 lerp，否则结果可能为 nan
    float mstd2 = mstd1 >= 1.192092896e-7 ? rsqrt(mstd1) : 0.0;
    mstd1 *= mstd2;

    float vsum = 0.0, wsum = 0.0, sum1, sum2;

    sum1 = W(0, -1123354974, -1118620174, 1016130204, -1103968288) + W(1, -1101453425, -1117908518, -1122284590, -1122818124) + W(2, -1112248839, 1024662558, -1087068557, 1048182784) + W(3, 1059583965, -1119323982, 1027638054, -1137723992) + W(4, 1046299686, 1028038478, 1063313277, 1047279381) + W(5, -1088182320, 1034186247, -1124394588, 978245507) + W(6, -1143613552, -1129268360, -1103342192, -1115088511) + W(7, 1003350800, -1134684248, -1111377363, 1028117438); sum2 = W(0, -1162931039, -1136248556, -1115594515, -1119907402) + W(1, 1022791334, 1017500018, -1156766128, 1014782692) + W(2, -1131063526, -1131086728, -1128443230, 1044675527) + W(3, -1107588397, -1111169922, -1125594766, -1135599628) + W(4, 1029801649, 1031011705, 1042762789, 1050674207) + W(5, 1009001220, -1112569685, -1148613464, -1114139175) + W(6, -1117642655, -1128864654, -1107118398, -1113986381) + W(7, -1186206458, 1017255694, 993928432, 1007622876); WS(1038828992, 1041685264);
    sum1 = W(0, -1114329248, 995958527, -1117673776, 1034401008) + W(1, 1038612842, 1035088196, 1008781376, 1029875310) + W(2, 1049950910, 1027336960, 1060640651, 1045782072) + W(3, -1098159517, -1106507532, -1124000392, -1105439902) + W(4, -1097681183, -1107326552, -1085831405, -1105157973) + W(5, 1053136924, 1032016120, 1023707152, 1034119968) + W(6, 1028668144, 1025858258, 1033402064, -1122828000) + W(7, -1110558370, -1113173980, 1012109856, -1114749520); sum2 = W(0, 1031315360, -1131767489, 1023637252, -1107869385) + W(1, -1107666272, -1117110288, -1124350185, -1110538107) + W(2, -1099468189, -1140834082, -1100127579, 1052854494) + W(3, 1034036134, 1024451620, 1003450083, 1041131277) + W(4, -1112139926, 1024287080, -1117241706, 1052996200) + W(5, 1027811452, 1027157968, -1131082337, 1035032776) + W(6, 1036663822, -1122285462, 1038018354, -1112496415) + W(7, -1110479054, -1112615559, 998992195, -1106762474); WS(-1086074680, 1053637716);
    sum1 = W(0, -1121345387, -1148805338, -1136570733, 1049266593) + W(1, 1027081787, -1133439181, -1158465386, -1120818857) + W(2, 1042002951, -1165378922, 1052460699, -1094571489) + W(3, -1124281856, 1040734807, -1121708851, 1035650578) + W(4, -1113042450, -1115297518, -1107443934, -1098765182) + W(5, 1043313411, 1006695533, 1016359031, 1027853163) + W(6, -1121398619, 991217235, -1117268427, 1036113926) + W(7, -1136658365, -1112513138, 1021173351, -1106476275); sum2 = W(0, 1026517575, 1017334370, 1051558711, 1071692777) + W(1, 1049822619, 1020207734, 1022251878, 1019995718) + W(2, -1170492850, 1003954710, -1096673587, -1077357700) + W(3, -1098179385, 996694924, -1122577241, 1015494226) + W(4, -1138816415, -1132363566, -1136175651, -1098960792) + W(5, -1116986501, 1003290486, -1141894102, -1126828734) + W(6, -1143472678, 998846550, -1124275402, 1018703670) + W(7, 1007812651, 1007766851, 1009415395, -1163222937); WS(1051521136, 1027207116);
    sum1 = W(0, -1122694020, -1121133108, -1102175837, -1116351908) + W(1, 1045518980, 1009393969, 1008379217, 1015772516) + W(2, 1010830545, -1124202632, 1057246783, 1026322980) + W(3, -1089509425, 1025178484, -1117338572, 1009646833) + W(4, -1124291704, 1037913146, -1093542759, 982577970) + W(5, 1055793637, -1118947636, 1001093793, 1001810977) + W(6, 1018062184, -1116091286, 1041281977, -1125394504) + W(7, 1008755233, -1127575032, 1015898776, -1121163492); sum2 = W(0, -1137495011, 1013616911, -1135578111, 1029346938) + W(1, 1017473747, 1012413655, -1133405571, 1008139351) + W(2, -1135527491, -1123650952, 1013443151, -1114797945) + W(3, -1122100892, -1128721387, -1166794345, -1156685818) + W(4, 1027730022, 1024465134, 1049128967, 1068130737) + W(5, 1046423571, -1143058109, 1020545683, -1126785325) + W(6, -1118108263, -1128775579, -1098008683, -1080443718) + W(7, -1101482344, -1137148015, -1128178767, 991435034); WS(1057767608, -1132080751);
    sum1 = W(0, 1026028453, 1026017621, -1117947285, 1048679017) + W(1, 1025261389, 1011196341, 1015828970, 1025013027) + W(2, 1025766741, -1135552917, 1051769667, -1083959172) + W(3, -1120826122, 1045191525, 1028389741, 1039505775) + W(4, 1035118319, 1040474693, -1111744027, -1084413328) + W(5, 1049618505, -1110336171, 1028257397, -1123719333) + W(6, 1012106581, -1138611630, 1030333189, 1045191121) + W(7, -1122181545, 1030480605, 1027514349, 1020294666); sum2 = W(0, 1017587161, 1028118553, 1008167722, 1005112948) + W(1, -1125344655, 1015776789, -1148301500, -1138850406) + W(2, -1101123140, -1103020887, -1099714612, 1049070164) + W(3, 1032013714, 1022049457, 1009340114, -1167693540) + W(4, 1040188371, 1022642341, 1039093756, 1046164698) + W(5, -1111525569, -1098832696, -1115917000, -1103378287) + W(6, 988296658, 1010063898, 1026403646, 1033545355) + W(7, 1002132020, 1037334715, -1139728254, 1035581889); WS(-1099372256, -1088618788);
    sum1 = W(0, -1112538182, -1113349022, -1103996671, 1024020908) + W(1, 1046614908, -1111225386, -1110537326, -1114146165) + W(2, 1048693927, 1033711782, 1064716592, -1143605597) + W(3, -1085173359, 1004694493, -1108087402, -1138402062) + W(4, -1112344546, -1129092599, -1086749016, 1044926535) + W(5, 1062252083, 1040479887, 1034104622, 1042110371) + W(6, -1109099742, -1110127398, 1032699126, -1121424940) + W(7, -1130166943, -1106709441, -1120726228, -1106064827); sum2 = W(0, 987083788, -1144106823, -1120467381, -1121977305) + W(1, -1118651341, -1162389292, -1152635694, 964510307) + W(2, 1013472954, -1131186779, -1139561796, 1044091298) + W(3, 1038343490, -1115306287, -1155962630, -1117365756) + W(4, -1120418118, -1122269098, 1038342084, 1042996066) + W(5, -1118476220, -1128689408, -1132569906, -1141833923) + W(6, 979955865, -1163904780, -1115615181, -1127292875) + W(7, -1123141745, 1014320394, -1135582470, 1008840046); WS(1041282784, 1044242623);
    sum1 = W(0, -1119885764, -1119816052, -1100880653, -1113812594) + W(1, 1046531310, 1015358999, 1005085853, 1021011107) + W(2, -1171512555, -1121861252, 1057266723, 1010135439) + W(3, -1089952515, 1031135156, -1115226950, 1003139037) + W(4, 1003864029, 1040963149, -1094412795, -1118004569) + W(5, 1056310444, -1114099002, 1015234855, 992693307) + W(6, 1025494836, -1113504879, 1043843337, -1125989575) + W(7, -1156936827, -1122714492, 1003362397, -1120612644); sum2 = W(0, 1005317381, -1143827754, 1019060164, 1009279342) + W(1, 1014092605, -1131000233, 1012779564, -1137528453) + W(2, -1142619324, 1012902153, -1114788024, -1098688460) + W(3, -1120377499, 1017453102, -1139793504, -1147729078) + W(4, -1126266146, -1128784654, -1094218173, -1078812823) + W(5, -1099532818, 1007638067, -1130333980, 1018177647) + W(6, 1026462555, 1020893616, 1054132458, 1070492026) + W(7, 1048935725, 1011358224, 1015734963, 987943782); WS(1046635232, 1024078131);
    sum1 = W(0, 1002735212, 1025138813, 1017042555, -1132524982) + W(1, 1031803657, 1033606155, 1021596219, 1015508823) + W(2, 1035063871, 1034039879, 1044122447, -1110416695) + W(3, -1092481954, -1094320024, -1107502027, -1103391009) + W(4, -1097977761, -1105608655, -1094991056, 1051547730) + W(5, 1050188814, 1047410847, 1031346589, 1046101811) + W(6, 1040314319, 1035664624, 1038536855, -1114843703) + W(7, 1003107468, 1019470987, 1021345835, -1136683190); sum2 = W(0, -1096475926, -1112281069, -1116645717, 1041647377) + W(1, -1113263240, 1023473494, -1117017643, 1039764966) + W(2, 1044036812, -1112231286, -1111398905, -1096068583) + W(3, 1026411348, -1114320784, -1138574198, -1104710548) + W(4, 1052862983, 1024115789, 1051331710, 1038036111) + W(5, 1042458641, 1028002558, 1037890580, -1106844581) + W(6, -1106234474, -1121785528, -1130292776, 1037359643) + W(7, -1111704128, -1123406807, -1109714921, 1041123403); WS(-1088554040, -1076674880);
    sum1 = W(0, 1026292820, 1016736263, 1042339025, -1110236986) + W(1, -1103961368, 1016313655, -1151588920, 1014755782) + W(2, -1132973070, 1034501898, -1089525132, 1037427962) + W(3, 1056478885, -1118983748, 1038469390, -1123320716) + W(4, -1144171612, -1110973538, 1052671191, -1123890785) + W(5, -1092344862, 1041641985, 1010979982, 1017396903) + W(6, -1130131975, 1028857234, -1108906970, -1112145786) + W(7, 1002874044, 1025897228, -1130905399, 1033705562); sum2 = W(0, 1013915195, 1007730851, 981970521, 1028189234) + W(1, -1121038101, -1142484934, -1146368902, 1010322539) + W(2, -1133182691, 1024414743, -1111248658, 1040952978) + W(3, -1109339192, -1094377458, -1116592821, -1112421528) + W(4, -1127318198, -1121307593, 1035588225, 1057294107) + W(5, -1107404728, 1024397525, -1118541421, 1019759378) + W(6, 1020584890, 1005058566, -1124411850, 1029625115) + W(7, 1026110889, 1023925523, -1140327971, -1199698720); WS(1063581112, 1015292283);
    sum1 = W(0, -1123806598, -1124445804, 1036776315, -1112186771) + W(1, -1102837698, -1117642958, -1137018200, 1010580432) + W(2, -1125096044, 1037634467, -1083793455, -1098422117) + W(3, 1058965073, -1106625757, 1036181095, -1127761788) + W(4, 1046804719, 1028314614, 1064148787, 1034155462) + W(5, -1089226130, 1037373467, 994321759, 1021285644) + W(6, -1117498166, 1006823135, -1106689849, 1004978479) + W(7, 1033810693, 1029436414, -1119765454, 1034713459); sum2 = W(0, -1127012521, -1129458054, -1134632819, -1113739078) + W(1, -1106078947, -1115241196, -1122814807, -1119046895) + W(2, -1110373665, -1122115974, -1118435057, 1041258512) + W(3, 1025961773, 1041055451, 1025056413, 1029845331) + W(4, -1121983257, -1121551577, -1107711610, 1043546644) + W(5, 1048226293, -1131486243, -1139476701, 1018415015) + W(6, 1021812843, 1015201109, 1039413537, -1127386873) + W(7, -1110385416, -1135801459, -1132245806, -1140149017); WS(-1109010880, -1087548956);
    sum1 = W(0, 1034947768, 1034343312, 1016751552, 1019661856) + W(1, -1126501287, 1017025648, 1030724160, -1140792121) + W(2, -1095012676, -1102610188, -1096454908, -1091443170) + W(3, -1131030249, 1042942296, 1019936112, 1024647464) + W(4, 1046023882, 1039446704, 1042564604, -1105694067) + W(5, 1044246468, -1103700296, -1141422594, -1107855416) + W(6, 1029737824, 1025692706, 1038373096, 1039271048) + W(7, 1012879825, 1041317114, 1029263800, 1041193844); sum2 = W(0, 1034034732, -1113997103, 1028771217, 1025456143) + W(1, 1035315492, -1102403849, 1018212015, -1099438501) + W(2, -1107522705, -1121503695, -1114143244, -1105773446) + W(3, -1109746606, -1106040358, -1106459627, 1039219872) + W(4, -1105460279, 1038975878, 1032873918, 1059420344) + W(5, 1040681265, 1046039582, 1026290649, 1046943722) + W(6, 1021740679, -1112744336, -1121564954, 1024971971) + W(7, -1122379806, -1106873869, -1130313815, -1105420350); WS(-1086299832, -1077288694);
    sum1 = W(0, 1021716686, -1132921948, -1113901292, -1108835908) + W(1, 1023078294, 965138311, 998651320, -1130194922) + W(2, -1099039878, -1108540692, -1158126306, 1055092577) + W(3, -1089051407, -1113759276, -1107695832, -1113503632) + W(4, -1111509136, 1021468846, -1096197083, 1062013047) + W(5, 1050708993, 1022391342, -1133490396, 991635057) + W(6, 1039618828, -1131678690, 1041516082, -1118733319) + W(7, -1122936235, 1015065790, 997649137, 1023538631); sum2 = W(0, -1133976495, 1027343155, -1149877867, -1119506980) + W(1, -1126385541, 1016526837, 994153115, -1140785051) + W(2, 1035891239, 1030599513, 1037590422, 1054189655) + W(3, 1041308688, -1112736561, 1004824957, -1120347934) + W(4, -1130801609, -1108453664, 1012747883, -1119322812) + W(5, -1107379808, -1119223720, -1116360142, -1129452107) + W(6, -1113698362, 1016406968, -1108226898, -1120928356) + W(7, 1016225738, 988482485, 1018050885, -1117792638); WS(-1113279936, 1066223903);
    sum1 = W(0, -1128171420, -1141738481, -1138940153, 1044160156) + W(1, 1020686276, -1129655596, 964173357, -1123239900) + W(2, 1040261344, -1140107833, 1050703688, -1100167260) + W(3, -1130335589, 1035637471, -1124525100, 1032644739) + W(4, -1112013315, -1116929726, -1108200895, -1100730273) + W(5, 1040782300, 1024316286, 1014134393, 1029624526) + W(6, -1123695998, -1154978689, -1123177006, 1034288823) + W(7, -1141423761, -1114187043, 1013984857, -1108229911); sum2 = W(0, -1115606620, -1125272644, -1099614716, -1080575150) + W(1, -1102155153, -1122847678, -1123394906, -1129056732) + W(2, 1021458196, 1017345212, 1047257730, 1068148121) + W(3, 1044966894, 1026244022, 1017049220, 1010161976) + W(4, 1009639320, 1016051020, -1120838650, -1113655261) + W(5, -1132238288, -1130782536, 967940860, 1004223696) + W(6, -1131253088, -1143902384, 1020803060, 1032085971) + W(7, 1016311348, -1137376840, -1137115752, -1136984808); WS(1060545080, -1126581603);
    sum1 = W(0, 1032630360, 1037657648, 1043836232, 1037448680) + W(1, 976149203, 1031833596, 1031675647, 1025282125) + W(2, -1112268976, -1128752350, -1090205186, 1048595306) + W(3, 1057651571, 1035187792, 1034806588, 1043419290) + W(4, 1045186906, 1032285712, 1053340438, -1094666759) + W(5, -1082657749, -1092127852, -1104761760, -1096441814) + W(6, -1125010622, 1029508223, -1108078856, 1041691860) + W(7, 1042698525, 1040118132, 1033087420, 1034587656); sum2 = W(0, -1123698886, -1126365381, -1135914762, -1121651762) + W(1, -1118625490, -1122087574, -1147908244, -1134045690) + W(2, 1034075649, 1026991402, 1019253181, 1047572688) + W(3, 1035108181, -1115886918, 1016718341, -1117034488) + W(4, 998149095, -1118780236, 1023543366, 1038479879) + W(5, -1114677625, 1011684618, -1132109957, -1137057610) + W(6, -1113635181, -1168196508, -1114469118, -1145545780) + W(7, 992781287, -1139655050, -1142844852, 1007905050); WS(-1083899832, -1105526146);
    sum1 = W(0, 1026357515, -1139718894, 1044187583, -1105573131) + W(1, -1104526300, -1119529939, -1125768375, -1132776678) + W(2, -1119744955, -1125720471, -1092285679, 1062437883) + W(3, 1058460257, 1022150135, 1033366698, 1009731342) + W(4, -1117075907, -1106102943, 1048719011, 1052836221) + W(5, -1089717563, -1123085499, -1114009838, -1112611206) + W(6, -1111407198, -1152407445, -1107209883, -1107292779) + W(7, -1122559055, -1119739267, -1119196243, -1129505495); sum2 = W(0, -1110807022, -1129400032, -1105612607, -1123619892) + W(1, -1131262448, 1016529300, -1129444600, -1136239801) + W(2, 1025172792, -1117035240, 1035443403, -1135427545) + W(3, -1111010692, -1115955576, -1117326476, -1121250556) + W(4, 1033543849, 999654946, 1039345667, 1053020794) + W(5, 1047843748, -1135856481, 1022819536, 998047364) + W(6, -1123816828, -1144812946, -1120747576, -1113498942) + W(7, -1113301822, -1146605522, -1119691028, -1135792457); WS(-1107513792, 1064663354);
    sum1 = W(0, 1030862455, -1161118946, 1040244826, -1104300038) + W(1, -1102940181, -1135077628, -1135539484, 1011863892) + W(2, -1113532308, 1021510766, -1091621085, 1046262406) + W(3, 1054782000, 1019068110, 1036941280, -1128724830) + W(4, 1032378968, -1127591630, 1051734861, 1034822530) + W(5, -1095483267, 1031948820, -1172984259, -1120336759) + W(6, -1123071015, 1009770420, -1107582956, -1108820108) + W(7, -1125175670, 1025488559, -1126076542, 1036426604); sum2 = W(0, -1135206239, -1139065871, 1026230428, 1025917606) + W(1, 1027050280, 1013849783, 1016077019, -1127829351) + W(2, -1140752647, -1123380440, 988696695, -1092786651) + W(3, 1049996339, 1057784826, 1033822297, 1034470972) + W(4, 1022777359, 1021581075, -1122295168, -1085937537) + W(5, 1032573953, -1130048007, 1032545188, -1137094527) + W(6, 974924014, -1133276463, 1029689087, -1140169471) + W(7, -1135329695, -1124883951, 1011238415, 1001568686); WS(1058918200, -1121082995);
    return clamp(mstd0 + 5.0 * vsum / wsum * mstd1, 0.0, 1.0);
}

const static float2x3 rgb2uv = {
    -0.169, -0.331, 0.5,
    0.5, -0.419, -0.081
};

const static float3x3 yuv2rgb = {
    1, -0.00093, 1.401687,
    1, -0.3437, -0.71417,
    1, 1.77216, 0.00099
};

groupshared float inp[525];

void Pass2(uint2 blockStart, uint3 threadId) {
    const float2 inputPt = GetInputPt();

    const uint2 group_base = uint2(blockStart.x >> 1, blockStart.y);
    for (int id = threadId.x * MP_NUM_THREADS_Y + threadId.y; id < 525; id += MP_NUM_THREADS_X * MP_NUM_THREADS_Y) {
        uint x = (uint)id / 15, y = (uint)id % 15;
        inp[id] = tex1.SampleLevel(sam, inputPt * float2(group_base.x + x - 1 + 0.5, (group_base.y + y - 3 + 0.5) * 0.5), 0).r;
    }

    GroupMemoryBarrierWithGroupSync();

    uint2 destPos = blockStart + uint2(threadId.x * 2, threadId.y);
    if (!CheckViewport(destPos)) {
        return;
    }

    float4 ret = 0.0;
    float4 ret0 = 0.0;
    float4 samples[8];
    const uint local_pos = threadId.x * 15 + threadId.y;
    [unroll]
    for (int i = 0; i < 8; ++i) {
        [unroll]
        for (int j = 0; j < 4; ++j) {
            samples[i][j] = inp[local_pos + (i / 2) * 15 + (i % 2) * 4 + j];
        }
    }
    
    float2 originUV = mul(rgb2uv, INPUT.SampleLevel(sam, inputPt * (destPos / 2 + 0.5f), 0).rgb);

    WriteToOutput(destPos, mul(yuv2rgb, float3(samples[2][3], originUV)));

    ++destPos.x;
    if (!CheckViewport(destPos)) {
        return;
    }

    WriteToOutput(destPos, mul(yuv2rgb, float3(nnedi3(samples), originUV)));
}
