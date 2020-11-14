function em = set_vmodel ( modelname )
% % 
% %
% % function em = set_vmodel ( modelname )
% % 
% % modelname can be 'iasp91', 'prem' or 'ak135' 
% %
% % OUTPUT: 
% %
% % em is a  structure which has 
% % em.vp[] = vp; 
% % em.vs[] = vs; 
% % em.rho[] = rho; 
% % em.z[] = z; 
% % em.sp_fine[] = (re - z)./ vp; 
% % em.ss_fine[] = (re - z)./vs; 
% % em.re = max(z);
% % em.z_cmb =get_cmb (); 
% % em.z_660 =get_660 (); 
% % em.z_iob = get_iob (); 
% % author: yingcai zheng 
% % 
iasp91 =[
    % IASPEI91 P Model (138 layers) no "discontinuity" at 120, 760 km)
    %  IASPEI91 S Model (67 values to cmb)
    0.000    5.8000    3.3600    2.7200
    20.000    5.8000    3.3600    2.7200
    20.000    6.5000    3.7500    2.9200
    35.000    6.5000    3.7500    2.9200
    35.000    8.0400    4.4700    3.3198
    77.500    8.0450    4.4850    3.3455
    120.000    8.0500    4.5000    3.3713
    165.000    8.1750    4.5090    3.3985
    210.000    8.3000    4.5180    3.4258
    210.000    8.6000    4.5220    3.4258
    260.000    8.4825    4.6090    3.4561
    310.000    8.6650    4.6960    3.4864
    360.000    8.8475    4.7830    3.5167
    410.000    9.0300    4.8700    3.5470
    410.000    9.3600    5.0700    3.7557
    460.000    9.5280    5.1760    3.8175
    510.000    9.6960    5.2820    3.8793
    560.000    9.8640    5.3880    3.9410
    610.000   10.0320    5.4940    4.0028
    660.000   10.2000    5.6000    4.0646
    660.000   10.7900    5.9500    4.3714
    710.000   10.9229    6.0797    4.4010
    760.000   11.0558    6.2095    4.4305
    809.500   11.1440    6.2474    4.4596
    859.000   11.2300    6.2841    4.4885
    908.500   11.3140    6.3199    4.5173
    958.000   11.3960    6.3546    4.5459
    1007.500   11.4761    6.3883    4.5744
    1057.000   11.5543    6.4211    4.6028
    1106.500   11.6308    6.4530    4.6310
    1156.000   11.7056    6.4841    4.6591
    1205.500   11.7787    6.5143    4.6870
    1255.000   11.8504    6.5438    4.7148
    1304.500   11.9205    6.5725    4.7424
    1354.000   11.9893    6.6006    4.7699
    1403.500   12.0568    6.6280    4.7973
    1453.000   12.1231    6.6547    4.8245
    1502.500   12.1881    6.6809    4.8515
    1552.000   12.2521    6.7066    4.8785
    1601.500   12.3151    6.7317    4.9052
    1651.000   12.3772    6.7564    4.9319
    1700.500   12.4383    6.7807    4.9584
    1750.000   12.4987    6.8046    4.9847
    1799.500   12.5584    6.8282    5.0109
    1849.000   12.6174    6.8514    5.0370
    1898.500   12.6759    6.8745    5.0629
    1948.000   12.7339    6.8972    5.0887
    1997.500   12.7915    6.9199    5.1143
    2047.000   12.8487    6.9423    5.1398
    2096.500   12.9057    6.9647    5.1652
    2146.000   12.9625    6.9870    5.1904
    2195.500   13.0192    7.0093    5.2154
    2245.000   13.0758    7.0316    5.2403
    2294.500   13.1325    7.0540    5.2651
    2344.000   13.1892    7.0765    5.2898
    2393.500   13.2462    7.0991    5.3142
    2443.000   13.3034    7.1218    5.3386
    2492.500   13.3610    7.1449    5.3628
    2542.000   13.4190    7.1681    5.3869
    2591.500   13.4774    7.1917    5.4108
    2641.000   13.5364    7.2156    5.4345
    2690.500   13.5961    7.2398    5.4582
    2740.000   13.6564    7.2645    5.4817
    2740.000   13.6564    7.2645    5.4817
    2789.670   13.6679    7.2768    5.5051
    2839.330   13.6793    7.2892    5.5284
    2889.000   13.6908    7.3015    5.5515
    2889.000    8.0088    0.0000    9.9145
    2939.330    8.0963    0.0000    9.9942
    2989.660    8.1821    0.0000   10.0722
    3039.990    8.2662    0.0000   10.1485
    3090.320    8.3486    0.0000   10.2233
    3140.660    8.4293    0.0000   10.2964
    3190.990    8.5083    0.0000   10.3679
    3241.320    8.5856    0.0000   10.4378
    3291.650    8.6611    0.0000   10.5062
    3341.980    8.7350    0.0000   10.5731
    3392.310    8.8072    0.0000   10.6385
    3442.640    8.8776    0.0000   10.7023
    3492.970    8.9464    0.0000   10.7647
    3543.300    9.0134    0.0000   10.8257
    3593.640    9.0787    0.0000   10.8852
    3643.970    9.1424    0.0000   10.9434
    3694.300    9.2043    0.0000   11.0001
    3744.630    9.2645    0.0000   11.0555
    3794.960    9.3230    0.0000   11.1095
    3845.290    9.3798    0.0000   11.1623
    3895.620    9.4349    0.0000   11.2137
    3945.950    9.4883    0.0000   11.2639
    3996.280    9.5400    0.0000   11.3127
    4046.620    9.5900    0.0000   11.3604
    4096.950    9.6383    0.0000   11.4069
    4147.280    9.6848    0.0000   11.4521
    4197.610    9.7297    0.0000   11.4962
    4247.940    9.7728    0.0000   11.5391
    4298.270    9.8143    0.0000   11.5809
    4348.600    9.8540    0.0000   11.6216
    4398.930    9.8920    0.0000   11.6612
    4449.260    9.9284    0.0000   11.6998
    4499.600    9.9630    0.0000   11.7373
    4549.930    9.9959    0.0000   11.7737
    4600.260   10.0271    0.0000   11.8092
    4650.590   10.0566    0.0000   11.8437
    4700.920   10.0844    0.0000   11.8772
    4751.250   10.1105    0.0000   11.9098
    4801.580   10.1349    0.0000   11.9414
    4851.910   10.1576    0.0000   11.9722
    4902.240   10.1785    0.0000   12.0021
    4952.580   10.1978    0.0000   12.0311
    5002.910   10.2154    0.0000   12.0593
    5053.240   10.2312    0.0000   12.0867
    5103.570   10.2454    0.0000   12.1133
    5153.900   10.2578    0.0000   12.1391
    5153.900   11.0914    3.4385   12.7037
    5204.610   11.1036    3.4488   12.7289
    5255.320   11.1153    3.4587   12.7530
    5306.040   11.1265    3.4681   12.7760
    5356.750   11.1371    3.4770   12.7980
    5407.460   11.1472    3.4856   12.8188
    5458.170   11.1568    3.4937   12.8387
    5508.890   11.1659    3.5013   12.8574
    5559.600   11.1745    3.5085   12.8751
    5610.310   11.1825    3.5153   12.8917
    5661.020   11.1901    3.5217   12.9072
    5711.740   11.1971    3.5276   12.9217
    5762.450   11.2036    3.5330   12.9351
    5813.160   11.2095    3.5381   12.9474
    5863.870   11.2150    3.5427   12.9586
    5914.590   11.2199    3.5468   12.9688
    5965.300   11.2243    3.5505   12.9779
    6016.010   11.2282    3.5538   12.9859
    6066.720   11.2316    3.5567   12.9929
    6117.440   11.2345    3.5591   12.9988
    6168.150   11.2368    3.5610   13.0036
    6218.860   11.2386    3.5626   13.0074
    6269.570   11.2399    3.5637   13.0100
    6320.290   11.2407    3.5643   13.0117
    6371.000   11.2409    3.5645   13.0122];

ak135 =[
    0.000      5.8000      3.4600     2.7200
    20.000      5.8000      3.4600      2.7200
    20.000      6.5000      3.8500      2.9200
    35.000      6.5000      3.8500      2.9200
    35.000      8.0400      4.4800      3.3198
    77.500      8.0450      4.4900      3.3455
    120.000      8.0500      4.5000      3.3713
    165.000      8.1750      4.5090      3.3985
    210.000      8.3000      4.5180      3.4258
    210.000      8.3000      4.5230      3.4258
    260.000      8.4825      4.6090      3.4561
    310.000      8.6650      4.6960      3.4864
    360.000      8.8475      4.7830      3.5167
    410.000      9.0300      4.8700      3.5470
    410.000      9.3600      5.0800      3.7557
    460.000      9.5280      5.1860      3.8175
    510.000      9.6960      5.2920      3.8793
    560.000      9.8640      5.3980      3.9410
    610.000     10.0320      5.5040      4.0028
    660.000     10.2000      5.6100      4.0646
    660.000     10.7900      5.9600      4.3714
    710.000     10.9229      6.0897      4.4010
    760.000     11.0558      6.2095      4.4305
    809.500     11.1353      6.2426      4.4596
    859.000     11.2221      6.2798      4.4885
    908.500     11.3068      6.3160      4.5173
    958.000     11.3896      6.3512      4.5459
    1007.500     11.4705      6.3854      4.5744
    1057.000     11.5495      6.4187      4.6028
    1106.500     11.6269      6.4510      4.6310
    1156.000     11.7026      6.4828      4.6591
    1205.500     11.7766      6.5138      4.6870
    1255.000     11.8491      6.5439      4.7148
    1304.500     11.9200      6.5727      4.7424
    1354.000     11.9895      6.6008      4.7699
    1403.500     12.0577      6.6285      4.7973
    1453.000     12.1245      6.6555      4.8245
    1502.500     12.1912      6.6815      4.8515
    1552.000     12.2550      6.7073      4.8785
    1601.500     12.3185      6.7326      4.9052
    1651.000     12.3819      6.7573      4.9319
    1700.500     12.4426      6.7815      4.9584
    1750.000     12.5031      6.8052      4.9847
    1799.500     12.5631      6.8286      5.0109
    1849.000     12.6221      6.8515      5.0370
    1898.500     12.6804      6.8742      5.0629
    1948.000     12.7382      6.8972      5.0887
    1997.500     12.7956      6.9194      5.1143
    2047.000     12.8526      6.9418      5.1398
    2096.500     12.9096      6.9627      5.1652
    2146.000     12.9668      6.9855      5.1904
    2195.500     13.0222      7.0063      5.2154
    2245.000     13.0783      7.0281      5.2403
    2294.500     13.1336      7.0500      5.2651
    2344.000     13.1894      7.0720      5.2898
    2393.500     13.2465      7.0931      5.3142
    2443.000     13.3018      7.1144      5.3386
    2492.500     13.3585      7.1369      5.3628
    2542.000     13.4156      7.1586      5.3869
    2591.500     13.4741      7.1807      5.4108
    2640.000     13.5312      7.2031      5.4345
    2690.000     13.5900      7.2258      5.4582
    2740.000     13.6494      7.2490      5.4817
    2740.000     13.6494      7.2490      5.4817
    2789.670     13.6530      7.2597      5.5051
    2839.330     13.6566      7.2704      5.5284
    2891.500     13.6602      7.2811      5.5515
    2891.500      8.0000      0.0000      9.9145
    2939.330      8.0382      0.0000      9.9942
    2989.660      8.1283      0.0000     10.0722
    3039.990      8.2213      0.0000     10.1485
    3090.320      8.3122      0.0000     10.2233
    3140.660      8.4001      0.0000     10.2964
    3190.990      8.4861      0.0000     10.3679
    3241.320      8.5692      0.0000     10.4378
    3291.650      8.6496      0.0000     10.5062
    3341.980      8.7283      0.0000     10.5731
    3392.310      8.8036      0.0000     10.6385
    3442.640      8.8761      0.0000     10.7023
    3492.970      8.9461      0.0000     10.7647
    3543.300      9.0138      0.0000     10.8257
    3593.640      9.0792      0.0000     10.8852
    3643.970      9.1426      0.0000     10.9434
    3694.300      9.2042      0.0000     11.0001
    3744.630      9.2634      0.0000     11.0555
    3794.960      9.3205      0.0000     11.1095
    3845.290      9.3760      0.0000     11.1623
    3895.620      9.4297      0.0000     11.2137
    3945.950      9.4814      0.0000     11.2639
    3996.280      9.5306      0.0000     11.3127
    4046.620      9.5777      0.0000     11.3604
    4096.950      9.6232      0.0000     11.40690
    4147.280      9.6673      0.0000     11.4521
    4197.610      9.7100      0.0000     11.4962
    4247.940      9.7513      0.0000     11.5391
    4298.270      9.7914      0.0000     11.5809
    4348.600      9.8304      0.0000     11.6216
    4398.930      9.8682      0.0000     11.6612
    4449.260      9.9051      0.0000     11.6998
    4499.600      9.9410      0.0000     11.7373
    4549.930      9.9761      0.0000     11.7737
    4600.260     10.0103      0.0000     11.8092
    4650.590     10.0439      0.0000     11.8437
    4700.920     10.0768      0.0000     11.8772
    4801.580     10.1415      0.0000     11.94140
    4851.910     10.1739      0.0000     11.9722
    4902.240     10.2049      0.0000     12.0001
    4952.580     10.2329      0.0000     12.0311
    5002.910     10.2565      0.0000     12.0593
    5053.240     10.2745      0.0000     12.0867
    5103.570     10.2854      0.0000     12.1133
    5153.500     10.2890      0.0000     12.1391
    5153.500     11.0427      3.5043     12.7037
    5204.610     11.0585      3.5187     12.7289
    5255.320     11.0718      3.5314     12.7530
    5306.040     11.0850      3.5435     12.7760
    5356.750     11.0983      3.5551     12.7980
    5407.460     11.1166      3.5661     12.8188
    5458.170     11.1316      3.5765     12.8387
    5508.890     11.1457      3.5864     12.8574
    5559.600     11.1590      3.5957     12.8751
    5610.310     11.1715      3.6044     12.8917
    5661.020     11.1832      3.6126     12.9072
    5711.740     11.1941      3.6202     12.9217
    5813.160     11.2134      3.6337     12.9474
    5863.870     11.2219      3.6396     12.9586
    5914.590     11.2295      3.6450     12.9688
    5965.300     11.2364      3.6498     12.9779
    6016.010     11.2424      3.6540     12.9859
    6066.720     11.2477      3.6577     12.9929
    6117.440     11.2521      3.6608     12.9988
    6168.150     11.2557      3.6633     13.0036
    6218.860     11.2586      3.6653     13.0074
    6269.570     11.2606      3.6667     13.0100
    6320.290     11.2618      3.6675     13.0117
    6371.000     11.2622      3.6678     13.0122
    ];

prem = [0.00     5.80000   3.20000   2.60000    1456.0     600.0
    15.00     5.80000   3.20000   2.60000    1456.0     600.0
    15.00     6.80000   3.90000   2.90000    1350.0     600.0
    24.40     6.80000   3.90000   2.90000    1350.0     600.0
    % mantle
    24.40     8.11061   4.49094   3.38076    1446.0     600.0
    40.00     8.10119   4.48486   3.37906    1446.0     600.0
    60.00     8.08907   4.47715   3.37688    1447.0     600.0
    80.00     8.07688   4.46953   3.37471     195.0      80.0
    115.00     8.05540   4.45643   3.37091     195.0      80.0
    150.00     8.03370   4.44361   3.36710     195.0      80.0
    185.00     8.01180   4.43108   3.36330     195.0      80.0
    220.00     7.98970   4.41885   3.35950     195.0      80.0
    220.00     8.55896   4.64391   3.43578     362.0     143.0
    265.00     8.64552   4.67540   3.46264     365.0     143.0
    310.00     8.73209   4.70690   3.48951     367.0     143.0
    355.00     8.81867   4.73840   3.51639     370.0     143.0
    400.00     8.90522   4.76989   3.54325     372.0     143.0
    400.00     9.13397   4.93259   3.72378     366.0     143.0
    450.00     9.38990   5.07842   3.78678     365.0     143.0
    500.00     9.64588   5.22428   3.84980     364.0     143.0
    550.00     9.90185   5.37014   3.91282     363.0     143.0
    600.00    10.15782   5.51602   3.97584     362.0     143.0
    635.00    10.21203   5.54311   3.98399     362.0     143.0
    670.00    10.26622   5.57020   3.99214     362.0     143.0
    670.00    10.75131   5.94508   4.38071     759.0     312.0
    721.00    10.91005   6.09418   4.41241     744.0     312.0
    771.00    11.06557   6.24046   4.44317     730.0     312.0
    871.00    11.24490   6.31091   4.50372     737.0     312.0
    971.00    11.41560   6.37813   4.56307     743.0     312.0
    1071.00    11.57828   6.44232   4.62129     750.0     312.0
    1171.00    11.73357   6.50370   4.67844     755.0     312.0
    1271.00    11.88209   6.56250   4.73460     761.0     312.0
    1371.00    12.02445   6.61891   4.78983     766.0     312.0
    1471.00    12.16126   6.67317   4.84422     770.0     312.0
    1571.00    12.29316   6.72548   4.89783     775.0     312.0
    1671.00    12.42075   6.77606   4.95073     779.0     312.0
    1771.00    12.54466   6.82512   5.00299     784.0     312.0
    1871.00    12.66550   6.87289   5.05469     788.0     312.0
    1971.00    12.78389   6.91957   5.10590     792.0     312.0
    2071.00    12.90045   6.96538   5.15669     795.0     312.0
    2171.00    13.01579   7.01053   5.20713     799.0     312.0
    2271.00    13.13055   7.05525   5.25729     803.0     312.0
    2371.00    13.24532   7.09974   5.30724     807.0     312.0
    2471.00    13.36074   7.14423   5.35706     811.0     312.0
    2571.00    13.47742   7.18892   5.40681     815.0     312.0
    2671.00    13.59597   7.23403   5.45657     819.0     312.0
    2741.00    13.68041   7.26597   5.49145     822.0     312.0
    2771.00    13.68753   7.26575   5.50642     823.0     312.0
    2871.00    13.71168   7.26486   5.55641     826.0     312.0
    2891.00    13.71660   7.26466   5.56645     826.0     312.0
    % outer-core
    2891.00     8.06482   0.00000   9.90349   57822.0       0.0
    2971.00     8.19939   0.00000  10.02940   57822.0       0.0
    3071.00     8.36019   0.00000  10.18134   57822.0       0.0
    3171.00     8.51298   0.00000  10.32726   57822.0       0.0
    3271.00     8.65805   0.00000  10.46727   57822.0       0.0
    3371.00     8.79573   0.00000  10.60152   57822.0       0.0
    3471.00     8.92632   0.00000  10.73012   57822.0       0.0
    3571.00     9.05015   0.00000  10.85321   57822.0       0.0
    3671.00     9.16752   0.00000  10.97091   57822.0       0.0
    3771.00     9.27867   0.00000  11.08335   57822.0       0.0
    3871.00     9.38418   0.00000  11.19067   57822.0       0.0
    3971.00     9.48409   0.00000  11.29298   57822.0       0.0
    4017.00     9.57881   0.00000  11.39042   57822.0       0.0
    4171.00     9.66865   0.00000  11.48311   57822.0       0.0
    4271.00     9.75393   0.00000  11.57119   57822.0       0.0
    4371.00     9.83496   0.00000  11.65478   57822.0       0.0
    4471.00     9.91206   0.00000  11.73401   57822.0       0.0
    4571.00     9.98554   0.00000  11.80900   57822.0       0.0
    4671.00    10.05572   0.00000  11.87990   57822.0       0.0
    4771.00    10.12291   0.00000  11.94682   57822.0       0.0
    4871.00    10.18743   0.00000  12.00989   57822.0       0.0
    4971.00    10.24959   0.00000  12.06924   57822.0       0.0
    5071.00    10.30971   0.00000  12.12500   57822.0       0.0
    5149.50    10.35568   0.00000  12.16634   57822.0       0.0
    % inner-core
    5149.50    11.02827   3.50432  12.76360     445.0      85.0
    5171.00    11.03643   3.51002  12.77493     445.0      85.0
    5271.00    11.07249   3.53522  12.82501     443.0      85.0
    5371.00    11.10542   3.55823  12.87073     440.0      85.0
    5471.00    11.13521   3.57905  12.91211     439.0      85.0
    5571.00    11.16186   3.59767  12.94912     437.0      85.0
    5671.00    11.18538   3.61411  12.98178     436.0      85.0
    5771.00    11.20576   3.62835  13.01009     434.0      85.0
    5871.00    11.22301   3.64041  13.03404     433.0      85.0
    5971.00    11.23712   3.65027  13.05364     432.0      85.0
    6071.00    11.24809   3.65794  13.06888     432.0      85.0
    6171.00    11.25593   3.66342  13.07977     431.0      85.0
    6271.00    11.26064   3.66670  13.08630     431.0      85.0
    6371.00    11.26220   3.66780  13.08848     431.0      85.0
    ];

tx2011 =[
    0.000000 0.000000 3.200000 0.000000
    3.500000 0.000000 3.200000 0.000000
    4.000000 0.000000 3.650000 0.000000
    34.000000 0.000000 3.750000 0.000000
    36.000000 0.000000 4.600000 0.000000
    60.000000 0.000000 4.600000 0.000000
    75.000000 0.000000 4.600000 0.000000
    100.000000 0.000000 4.600000 0.000000
    125.000000 0.000000 4.500000 0.000000
    150.000000 0.000000 4.500000 0.000000
    175.000000 0.000000 4.500000 0.000000
    200.000000 0.000000 4.480000 0.000000
    225.000000 0.000000 4.480000 0.000000
    250.000000 0.000000 4.480000 0.000000
    275.000000 0.000000 4.510000 0.000000
    300.000000 0.000000 4.570000 0.000000
    325.000000 0.000000 4.630000 0.000000
    350.000000 0.000000 4.680000 0.000000
    375.000000 0.000000 4.730000 0.000000
    395.000000 0.000000 4.770000 0.000000
    414.000000 0.000000 4.810000 0.000000
    416.000000 0.000000 5.050000 0.000000
    425.000000 0.000000 5.070000 0.000000
    450.000000 0.000000 5.110000 0.000000
    475.000000 0.000000 5.150000 0.000000
    500.000000 0.000000 5.190000 0.000000
    525.000000 0.000000 5.250000 0.000000
    550.000000 0.000000 5.290000 0.000000
    575.000000 0.000000 5.330000 0.000000
    600.000000 0.000000 5.390000 0.000000
    625.000000 0.000000 5.450000 0.000000
    645.000000 0.000000 5.520000 0.000000
    654.000000 0.000000 5.620000 0.000000
    656.000000 0.000000 5.830000 0.000000
    675.000000 0.000000 5.950000 0.000000
    700.000000 0.000000 6.070000 0.000000
    725.000000 0.000000 6.140000 0.000000
    750.000000 0.000000 6.190000 0.000000
    775.000000 0.000000 6.220000 0.000000
    800.000000 0.000000 6.240000 0.000000
    825.000000 0.000000 6.260000 0.000000
    850.000000 0.000000 6.279000 0.000000
    875.000000 0.000000 6.296000 0.000000
    900.000000 0.000000 6.313000 0.000000
    925.000000 0.000000 6.330000 0.000000
    950.000000 0.000000 6.346000 0.000000
    975.000000 0.000000 6.363000 0.000000
    1000.000000 0.000000 6.380000 0.000000
    1025.000000 0.000000 6.396000 0.000000
    1050.000000 0.000000 6.411000 0.000000
    1075.000000 0.000000 6.427000 0.000000
    1100.000000 0.000000 6.443000 0.000000
    1125.000000 0.000000 6.458000 0.000000
    1150.000000 0.000000 6.474000 0.000000
    1162.500000 0.000000 6.481000 0.000000
    1175.000000 0.000000 6.489000 0.000000
    1187.500000 0.000000 6.497000 0.000000
    1200.000000 0.000000 6.504000 0.000000
    1212.500000 0.000000 6.511000 0.000000
    1225.000000 0.000000 6.518000 0.000000
    1237.500000 0.000000 6.525000 0.000000
    1250.000000 0.000000 6.532000 0.000000
    1262.500000 0.000000 6.539000 0.000000
    1275.000000 0.000000 6.547000 0.000000
    1287.500000 0.000000 6.554000 0.000000
    1300.000000 0.000000 6.561000 0.000000
    1312.500000 0.000000 6.568000 0.000000
    1325.000000 0.000000 6.575000 0.000000
    1337.500000 0.000000 6.582000 0.000000
    1350.000000 0.000000 6.589000 0.000000
    1362.500000 0.000000 6.596000 0.000000
    1375.000000 0.000000 6.603000 0.000000
    1387.500000 0.000000 6.610000 0.000000
    1400.000000 0.000000 6.617000 0.000000
    1412.500000 0.000000 6.624000 0.000000
    1425.000000 0.000000 6.630000 0.000000
    1437.500000 0.000000 6.637000 0.000000
    1450.000000 0.000000 6.643000 0.000000
    1462.500000 0.000000 6.650000 0.000000
    1475.000000 0.000000 6.657000 0.000000
    1487.500000 0.000000 6.664000 0.000000
    1500.000000 0.000000 6.670000 0.000000
    1512.500000 0.000000 6.677000 0.000000
    1525.000000 0.000000 6.683000 0.000000
    1537.500000 0.000000 6.690000 0.000000
    1550.000000 0.000000 6.696000 0.000000
    1562.500000 0.000000 6.703000 0.000000
    1575.000000 0.000000 6.709000 0.000000
    1587.500000 0.000000 6.716000 0.000000
    1600.000000 0.000000 6.722000 0.000000
    1612.500000 0.000000 6.728000 0.000000
    1625.000000 0.000000 6.734000 0.000000
    1637.500000 0.000000 6.741000 0.000000
    1650.000000 0.000000 6.747000 0.000000
    1662.500000 0.000000 6.753000 0.000000
    1675.000000 0.000000 6.759000 0.000000
    1687.500000 0.000000 6.766000 0.000000
    1700.000000 0.000000 6.772000 0.000000
    1712.500000 0.000000 6.778000 0.000000
    1725.000000 0.000000 6.784000 0.000000
    1737.500000 0.000000 6.790000 0.000000
    1750.000000 0.000000 6.796000 0.000000
    1762.500000 0.000000 6.803000 0.000000
    1775.000000 0.000000 6.809000 0.000000
    1787.500000 0.000000 6.815000 0.000000
    1800.000000 0.000000 6.821000 0.000000
    1812.500000 0.000000 6.827000 0.000000
    1825.000000 0.000000 6.833000 0.000000
    1837.500000 0.000000 6.839000 0.000000
    1850.000000 0.000000 6.845000 0.000000
    1862.500000 0.000000 6.850000 0.000000
    1875.000000 0.000000 6.856000 0.000000
    1887.500000 0.000000 6.862000 0.000000
    1900.000000 0.000000 6.868000 0.000000
    1912.500000 0.000000 6.873000 0.000000
    1925.000000 0.000000 6.879000 0.000000
    1937.500000 0.000000 6.885000 0.000000
    1950.000000 0.000000 6.891000 0.000000
    1962.500000 0.000000 6.896000 0.000000
    1975.000000 0.000000 6.902000 0.000000
    1987.500000 0.000000 6.908000 0.000000
    2000.000000 0.000000 6.914000 0.000000
    2012.500000 0.000000 6.919000 0.000000
    2025.000000 0.000000 6.925000 0.000000
    2037.500000 0.000000 6.931000 0.000000
    2050.000000 0.000000 6.937000 0.000000
    2062.500000 0.000000 6.942000 0.000000
    2075.000000 0.000000 6.948000 0.000000
    2087.500000 0.000000 6.954000 0.000000
    2100.000000 0.000000 6.960000 0.000000
    2112.500000 0.000000 6.965000 0.000000
    2125.000000 0.000000 6.971000 0.000000
    2137.500000 0.000000 6.977000 0.000000
    2150.000000 0.000000 6.983000 0.000000
    2162.500000 0.000000 6.988000 0.000000
    2175.000000 0.000000 6.994000 0.000000
    2187.500000 0.000000 6.999000 0.000000
    2200.000000 0.000000 7.005000 0.000000
    2212.500000 0.000000 7.010000 0.000000
    2225.000000 0.000000 7.016000 0.000000
    2237.500000 0.000000 7.021000 0.000000
    2250.000000 0.000000 7.027000 0.000000
    2262.500000 0.000000 7.032000 0.000000
    2275.000000 0.000000 7.038000 0.000000
    2287.500000 0.000000 7.043000 0.000000
    2300.000000 0.000000 7.049000 0.000000
    2312.500000 0.000000 7.055000 0.000000
    2325.000000 0.000000 7.060000 0.000000
    2337.500000 0.000000 7.065000 0.000000
    2350.000000 0.000000 7.071000 0.000000
    2362.500000 0.000000 7.077000 0.000000
    2375.000000 0.000000 7.083000 0.000000
    2387.500000 0.000000 7.089000 0.000000
    2400.000000 0.000000 7.094000 0.000000
    2412.500000 0.000000 7.099000 0.000000
    2425.000000 0.000000 7.105000 0.000000
    2437.500000 0.000000 7.110000 0.000000
    2450.000000 0.000000 7.116000 0.000000
    2462.500000 0.000000 7.122000 0.000000
    2475.000000 0.000000 7.127000 0.000000
    2487.500000 0.000000 7.132000 0.000000
    2500.000000 0.000000 7.138000 0.000000
    2512.500000 0.000000 7.143000 0.000000
    2525.000000 0.000000 7.149000 0.000000
    2537.500000 0.000000 7.155000 0.000000
    2550.000000 0.000000 7.161000 0.000000
    2562.500000 0.000000 7.166000 0.000000
    2575.000000 0.000000 7.171000 0.000000
    2587.500000 0.000000 7.176000 0.000000
    2600.000000 0.000000 7.182000 0.000000
    2612.500000 0.000000 7.191000 0.000000
    2625.000000 0.000000 7.200000 0.000000
    2637.500000 0.000000 7.222000 0.000000
    2650.000000 0.000000 7.245000 0.000000
    2662.500000 0.000000 7.267000 0.000000
    2675.000000 0.000000 7.290000 0.000000
    2687.500000 0.000000 7.287000 0.000000
    2700.000000 0.000000 7.285000 0.000000
    2712.500000 0.000000 7.283000 0.000000
    2725.000000 0.000000 7.280000 0.000000
    2737.500000 0.000000 7.277000 0.000000
    2750.000000 0.000000 7.275000 0.000000
    2762.500000 0.000000 7.273000 0.000000
    2775.000000 0.000000 7.270000 0.000000
    2787.500000 0.000000 7.267000 0.000000
    2800.000000 0.000000 7.265000 0.000000
    2811.400000 0.000000 7.264000 0.000000
    2822.800000 0.000000 7.263000 0.000000
    2834.100000 0.000000 7.261000 0.000000
    2845.500000 0.000000 7.260000 0.000000
    2856.900000 0.000000 7.259000 0.000000
    2868.200000 0.000000 7.257000 0.000000
    2879.600000 0.000000 7.256000 0.000000
    2891.000000 0.000000 7.255000 0.000000
    2891.500      8.0000      0.0000      9.9145
    2939.330      8.0382      0.0000      9.9942
    2989.660      8.1283      0.0000     10.0722
    3039.990      8.2213      0.0000     10.1485
    3090.320      8.3122      0.0000     10.2233
    3140.660      8.4001      0.0000     10.2964
    3190.990      8.4861      0.0000     10.3679
    3241.320      8.5692      0.0000     10.4378
    3291.650      8.6496      0.0000     10.5062
    3341.980      8.7283      0.0000     10.5731
    3392.310      8.8036      0.0000     10.6385
    3442.640      8.8761      0.0000     10.7023
    3492.970      8.9461      0.0000     10.7647
    3543.300      9.0138      0.0000     10.8257
    3593.640      9.0792      0.0000     10.8852
    3643.970      9.1426      0.0000     10.9434
    3694.300      9.2042      0.0000     11.0001
    3744.630      9.2634      0.0000     11.0555
    3794.960      9.3205      0.0000     11.1095
    3845.290      9.3760      0.0000     11.1623
    3895.620      9.4297      0.0000     11.2137
    3945.950      9.4814      0.0000     11.2639
    3996.280      9.5306      0.0000     11.3127
    4046.620      9.5777      0.0000     11.3604
    4096.950      9.6232      0.0000     11.40690
    4147.280      9.6673      0.0000     11.4521
    4197.610      9.7100      0.0000     11.4962
    4247.940      9.7513      0.0000     11.5391
    4298.270      9.7914      0.0000     11.5809
    4348.600      9.8304      0.0000     11.6216
    4398.930      9.8682      0.0000     11.6612
    4449.260      9.9051      0.0000     11.6998
    4499.600      9.9410      0.0000     11.7373
    4549.930      9.9761      0.0000     11.7737
    4600.260     10.0103      0.0000     11.8092
    4650.590     10.0439      0.0000     11.8437
    4700.920     10.0768      0.0000     11.8772
    4801.580     10.1415      0.0000     11.94140
    4851.910     10.1739      0.0000     11.9722
    4902.240     10.2049      0.0000     12.0001
    4952.580     10.2329      0.0000     12.0311
    5002.910     10.2565      0.0000     12.0593
    5053.240     10.2745      0.0000     12.0867
    5103.570     10.2854      0.0000     12.1133
    5153.500     10.2890      0.0000     12.1391
    5153.500     11.0427      3.5043     12.7037
    5204.610     11.0585      3.5187     12.7289
    5255.320     11.0718      3.5314     12.7530
    5306.040     11.0850      3.5435     12.7760
    5356.750     11.0983      3.5551     12.7980
    5407.460     11.1166      3.5661     12.8188
    5458.170     11.1316      3.5765     12.8387
    5508.890     11.1457      3.5864     12.8574
    5559.600     11.1590      3.5957     12.8751
    5610.310     11.1715      3.6044     12.8917
    5661.020     11.1832      3.6126     12.9072
    5711.740     11.1941      3.6202     12.9217
    5813.160     11.2134      3.6337     12.9474
    5863.870     11.2219      3.6396     12.9586
    5914.590     11.2295      3.6450     12.9688
    5965.300     11.2364      3.6498     12.9779
    6016.010     11.2424      3.6540     12.9859
    6066.720     11.2477      3.6577     12.9929
    6117.440     11.2521      3.6608     12.9988
    6168.150     11.2557      3.6633     13.0036
    6218.860     11.2586      3.6653     13.0074
    6269.570     11.2606      3.6667     13.0100
    6320.290     11.2618      3.6675     13.0117
    6371.000     11.2622      3.6678     13.0122
    ];



% disp(modelname);

if strcmp(modelname, 'prem'),
    EM = prem;    
elseif strcmp( modelname, 'iasp91'),
    EM = iasp91;
elseif strcmp(modelname, 'ak135'),
    EM = ak135;
elseif strcmp(modelname,'TX2011_ref')
    EM = tx2011;
else
    disp ( 'not a sensible model ') ;
end
z = EM(:,1);  vp = EM(:,2);  vs = EM(:, 3);  rho = EM(:, 4); 
if size(EM,2) >= 6
    qp = EM(:,5); qs = EM(:,6);
else
    qp = zeros(size(z));
    qs = qp;
end
re = max (z); 
NL = length(z);

% set some parameters

em.vp = vp; 
em.vs = vs; 
em.rho = rho; 
em.z = z; 
em.qp = qp;
em.qs = qs;
em.sp_fine = (re - z)./ vp; 
em.ss_fine = (re - z)./vs; 
em.re = max(z);
em.z_cmb =get_cmb (); 
em.z_660 =get_660 (); 
em.z_iob = get_iob (); 
 
% !//--------------------------------------------------------------
    function z_660 =  get_660 ()
        for j =1: NL-1
            zj1 = z(j) ;
            zj2 = z(j+1);
            if ( abs (zj1-zj2) < 1.e-3 && abs(zj1 - 660.) < 20. ) ,
                z_660 = zj1;
                return;
            end
        end
    end %subroutine get_660
% !//--------------------------------------------------------------
    function z_iob = get_iob()
        for j =1: NL-1
            zj1 = z(j);
            zj2 = z(j+1);
            if (abs (zj1-zj2) < 1.e-3 && vs(j) < 1.0e-6 && vs(j+1) > 1.) ,
                z_iob = z(j+1);
                return;
            end
        end
    end %subroutine get_iob
% !//--------------------------------------------------------------
    function z_cmb = get_cmb ()
        for j =1: NL
            if ( abs( vs(j) ) < 1.0e-6) ,
                z_cmb = z(j) ;
                return ;
            end
        end
    end %subroutine get_cmb
end
