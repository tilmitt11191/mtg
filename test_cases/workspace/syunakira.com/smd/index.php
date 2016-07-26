

<!DOCTYPE html>
<html>
<meta charset=UTF-8>
<head>
    <link rel="stylesheet" type="text/css" href="smd.css" />
    <link rel="shortcut icon" href="http://syunakira.com/smd/img/bookmark.png" type="image/png">
    <meta name="description" content="Statistical Magic Draft Simulator">
    <meta name="keywords" content="ドラフトシミュレーター,マジック・ザ・ギャザリング,MTG,統計,ドラフト">
    <meta name="viewport" content="width=device-width">
    <script>
        var packNameList = JSON.parse('["EldritchMoom","ETERNALMASTERS","UnravelTheMadness","OathOfTheGateWatch","BattleForZendikar","COMMANDER2015","MAGICORIGINS","ModernMasters2015","DRAGONSOFTARKIR","FATEREFORGED","KhansOfTarkir","M15","CONSPIRACY","JOURNEYINTONYX","BORNOFTHEGODS","THEROS","M14","ModernMasters","DragonsMage","Gatecrash","ReturntoRavnica"]');
        var packsLanguages = JSON.parse('{"EldritchMoom":["English","Japanese"],"ETERNALMASTERS":["English","Japanese"],"UnravelTheMadness":["English","Japanese"],"OathOfTheGateWatch":["English","Japanese"],"BattleForZendikar":["English","Japanese"],"COMMANDER2015":["English","Japanese"],"MAGICORIGINS":["English","Japanese"],"ModernMasters2015":["English","Japanese"],"DRAGONSOFTARKIR":["English","Japanese"],"FATEREFORGED":["English","Deutsch","Japanese"],"KhansOfTarkir":["English","Deutsch","Japanese"],"M15":["English","Japanese"],"CONSPIRACY":["English","Japanese"],"JOURNEYINTONYX":["English","Japanese"],"BORNOFTHEGODS":["English","Japanese"],"THEROS":["English","Japanese"],"M14":["English","Japanese"],"ModernMasters":["English"],"DragonsMage":["English","Japanese"],"Gatecrash":["English","Japanese"],"ReturntoRavnica":["English","Japanese"]}');
        var languagesForDisplay = JSON.parse('{"English":"English","Deutsch":"Deutsch","Japanese":"\u65e5\u672c\u8a9e"}');
    </script>
    <title>Statistical Magic Draft Simulator</title>
</head>

<body>
<center>

<table border="0" style="width: 1200px;">

<tr><td>
<style type="text/css">
    table .headerTable {
        width: 1200px;
        border: outset 2px #eeeeee;
        text-align: left;
    }
    table .headerTable tr {
        height: 58px;
        text-align: left;
    }
    table .headerTable td {
        margin: 10px;
        width: 140px;
        height: 38px;
    }
</style>


<div style="width: 1200px;">


<table class="headerTable"><tr>
    <td>
        <a href="http://syunakira.com/smd"><div class="draft">Draft</div></a>
    </td>
    <td>
        <a href="http://syunakira.com/smss"><div class="sealed">Sealed</div></a>
    </td>
    <td>
        <a href="chat"><div class="chat">chat room</div></a>
    </td>

    <td>
        <div style="margin: 15px;">
            <a href="https://twitter.com/share" class="twitter-share-button" data-url="http://syunakira.com/smd/" data-hashtags="smds">Tweet</a>
            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
        </div>
    </td>
    <td>
        <div style="margin: 15px;">
            <div id="fb-root"></div>
            <script>(function(d, s, id) {
                    var js, fjs = d.getElementsByTagName(s)[0];
                    if (d.getElementById(id)) return;
                    js = d.createElement(s); js.id = id;
                    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
                    fjs.parentNode.insertBefore(js, fjs);
                }(document, 'script', 'facebook-jssdk'));</script>
            <div class="fb-like" data-href="http://syunakira.com/smd/" data-send="false" data-layout="button_count" data-width="100" data-show-faces="false"></div>
        </div>
    </td>
    <td>
        <div style="margin: 15px;">
            <!-- Place this tag where you want the +1 button to render. -->
            <div class="g-plusone" data-size="medium"></div>

            <!-- Place this tag after the last +1 button tag. -->
            <script type="text/javascript">
                (function() {
                    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                    po.src = 'https://apis.google.com/js/plusone.js';
                    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
                })();
            </script>
        </div>
    </td>
    <td></td>
</tr></table>

<table><tr>
<td style="width:230px; font-size: 60px; color:#2266ff;">
    <a href="http://syunakira.com/smd/">
        <img src="http://syunakira.com/smd/img/logotype/smds.png" border="0" style="vertical-align: bottom;" alt="SMDS" height="90">
    </a>
</td>
<td style="width:970px;">
    <div>

        <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
        <!-- 970x90 for SMDS ビックバナー（大） -->
        <ins class="adsbygoogle"
             style="display:inline-block;width:970px;height:90px"
             data-ad-client="ca-pub-2941365993317354"
             data-ad-slot="5178906868"></ins>
        <script>
            (adsbygoogle = window.adsbygoogle || []).push({});
        </script>

    </div>
</td></tr></table>

</div></td></tr>

<tr style="width: 1200px;">
<td>

<table><tr>
<td width="200" style="vertical-align: top;">

    <div width="234" align="center">
        July.10/2016<br>
        <font color="#ff0000" style="font-size:18px;"><b>ELDRITCH MOON</b></font><br>
        May.29/2016<br>
        ETERNAL MASTERS<br>

        <!-- 広告 -->
        <div style="height:200px">
            <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
            <!-- 200x200 for SMDS スクエア -->
            <ins class="adsbygoogle"
                 style="display:inline-block;width:200px;height:200px"
                 data-ad-client="ca-pub-2941365993317354"
                 data-ad-slot="1588472062"></ins>
            <script>
                (adsbygoogle = window.adsbygoogle || []).push({});
            </script>
        </div>



                    <!-- Magic の TWITTER -->
            <div style="height:600px">
                <a class="twitter-timeline" href="https://twitter.com/mtgjp" data-widget-id="731799232001101825">@mtgjpさんのツイート</a>
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
            </div>

<a href="ad"><font style="font-size:18px;"><b>SMDS に広告を載せる</b></font></a>        <a href="http://syunakira.com/smss">
            <font style="font-size:18px;"><b>Sealed Simulator</b></font><br>
        </a>
    </div>

</td>
<td width="610" valign="top">

<center>

<h3>Welcome to Statistical Magic Draft Simulator(SMDS)</h3>

<font color="#2266ff" size="56px"><b> Draft Simulator </b></font>
<form method="post" action="drafting/index.php?status=startdraft" name="packSelect">
<p>pack1：<select name='pack1' onChange=changePack('Japanese')><option value='EldritchMoom'>  ELDRITCH MOON  </option><option value='ETERNALMASTERS'>  ETERNAL MASTERS  </option><option value='UnravelTheMadness'>  Shadows over Innistrad  </option><option value='OathOfTheGateWatch'>  Oath of the Gatewatch  </option><option value='BattleForZendikar'>  Battle For Zendikar  </option><option value='COMMANDER2015'>  COMMANDER 2015  </option><option value='MAGICORIGINS'>  MAGIC ORIGINS  </option><option value='ModernMasters2015'>  Modern Masters 2015  </option><option value='DRAGONSOFTARKIR'>  DRAGONS OF TARKIR  </option><option value='FATEREFORGED'>  FATE REFORGE  </option><option value='KhansOfTarkir'>  KHANS OF TARKIR  </option><option value='M15'>  Magic 2015  </option><option value='CONSPIRACY'>  CONSPIRACY  </option><option value='JOURNEYINTONYX'>  JOURNEY INTO NYX  </option><option value='BORNOFTHEGODS'>  BORN OF THE GODS  </option><option value='THEROS'>  THEROS  </option><option value='M14'>  Magic 2014  </option><option value='ModernMasters'>  Modern Masters  </option><option value='DragonsMage'>  Dragon's Maze  </option><option value='Gatecrash'>  Gatecrash  </option><option value='ReturntoRavnica'>  Return to Ravnica  </option></select></p><p>pack2：<select name='pack2' onChange=changePack('Japanese')><option value='EldritchMoom'>  ELDRITCH MOON  </option><option value='ETERNALMASTERS'>  ETERNAL MASTERS  </option><option value='UnravelTheMadness'>  Shadows over Innistrad  </option><option value='OathOfTheGateWatch'>  Oath of the Gatewatch  </option><option value='BattleForZendikar'>  Battle For Zendikar  </option><option value='COMMANDER2015'>  COMMANDER 2015  </option><option value='MAGICORIGINS'>  MAGIC ORIGINS  </option><option value='ModernMasters2015'>  Modern Masters 2015  </option><option value='DRAGONSOFTARKIR'>  DRAGONS OF TARKIR  </option><option value='FATEREFORGED'>  FATE REFORGE  </option><option value='KhansOfTarkir'>  KHANS OF TARKIR  </option><option value='M15'>  Magic 2015  </option><option value='CONSPIRACY'>  CONSPIRACY  </option><option value='JOURNEYINTONYX'>  JOURNEY INTO NYX  </option><option value='BORNOFTHEGODS'>  BORN OF THE GODS  </option><option value='THEROS'>  THEROS  </option><option value='M14'>  Magic 2014  </option><option value='ModernMasters'>  Modern Masters  </option><option value='DragonsMage'>  Dragon's Maze  </option><option value='Gatecrash'>  Gatecrash  </option><option value='ReturntoRavnica'>  Return to Ravnica  </option></select></p><p>pack3：<select name='pack3' onChange=changePack('Japanese')><option value='EldritchMoom'>  ELDRITCH MOON  </option><option value='ETERNALMASTERS'>  ETERNAL MASTERS  </option><option value='UnravelTheMadness'>  Shadows over Innistrad  </option><option value='OathOfTheGateWatch'>  Oath of the Gatewatch  </option><option value='BattleForZendikar'>  Battle For Zendikar  </option><option value='COMMANDER2015'>  COMMANDER 2015  </option><option value='MAGICORIGINS'>  MAGIC ORIGINS  </option><option value='ModernMasters2015'>  Modern Masters 2015  </option><option value='DRAGONSOFTARKIR'>  DRAGONS OF TARKIR  </option><option value='FATEREFORGED'>  FATE REFORGE  </option><option value='KhansOfTarkir'>  KHANS OF TARKIR  </option><option value='M15'>  Magic 2015  </option><option value='CONSPIRACY'>  CONSPIRACY  </option><option value='JOURNEYINTONYX'>  JOURNEY INTO NYX  </option><option value='BORNOFTHEGODS'>  BORN OF THE GODS  </option><option value='THEROS'>  THEROS  </option><option value='M14'>  Magic 2014  </option><option value='ModernMasters'>  Modern Masters  </option><option value='DragonsMage'>  Dragon's Maze  </option><option value='Gatecrash'>  Gatecrash  </option><option value='ReturntoRavnica'>  Return to Ravnica  </option></select></p>
<p>language：
<span id="selectPackLanguage">
<select name="language">
    <option value="English" >English</option>
    <option value="Japanese" selected>日本語</option>
</select></span></p>

<input type="hidden" name="status" value="startdraft">
<input type="submit" style="font-size:22px;" value="Draft Start" class="startButton"></p>
</form>

</center>

<!-- ここからランキングリンク -->
<center>

<font color="#ff6666" size="56px"><b> Point Ranking </b></font>

<form method="get" action="./pointranking/index.php" name="rankingSelect">

Select Pack：<select name='packname' onChange=changeRanking('Japanese')><option value='EldritchMoom'>  ELDRITCH MOON  </option><option value='ETERNALMASTERS'>  ETERNAL MASTERS  </option><option value='UnravelTheMadness'>  Shadows over Innistrad  </option><option value='OathOfTheGateWatch'>  Oath of the Gatewatch  </option><option value='BattleForZendikar'>  Battle For Zendikar  </option><option value='COMMANDER2015'>  COMMANDER 2015  </option><option value='MAGICORIGINS'>  MAGIC ORIGINS  </option><option value='ModernMasters2015'>  Modern Masters 2015  </option><option value='DRAGONSOFTARKIR'>  DRAGONS OF TARKIR  </option><option value='FATEREFORGED'>  FATE REFORGE  </option><option value='KhansOfTarkir'>  KHANS OF TARKIR  </option><option value='M15'>  Magic 2015  </option><option value='CONSPIRACY'>  CONSPIRACY  </option><option value='JOURNEYINTONYX'>  JOURNEY INTO NYX  </option><option value='BORNOFTHEGODS'>  BORN OF THE GODS  </option><option value='THEROS'>  THEROS  </option><option value='M14'>  Magic 2014  </option><option value='ModernMasters'>  Modern Masters  </option><option value='DragonsMage'>  Dragon's Maze  </option><option value='Gatecrash'>  Gatecrash  </option><option value='ReturntoRavnica'>  Return to Ravnica  </option></select>
<p>language：
<span id="selectRankingLanguage">
<select name="language">
    <option value="English" >English</option>
    <option value="Japanese" selected>日本語</option>
</select></span></p>

<input type="submit" style="font-size:22px;" value="See Ranking" class="pointRankingButton">
</form>
</center>
<!-- ランキングリンク終わり -->


<!-- ここからカード一覧 -->
<center>

<font color="#cccc44" size="56px"><b> Card List </b></font>

<form method="get" action="./cardlist" name="cardListSelect">

Select Pack：<select name='packname' onChange=changeCardList('Japanese')><option value='EldritchMoom'>  ELDRITCH MOON  </option><option value='ETERNALMASTERS'>  ETERNAL MASTERS  </option><option value='UnravelTheMadness'>  Shadows over Innistrad  </option><option value='OathOfTheGateWatch'>  Oath of the Gatewatch  </option><option value='BattleForZendikar'>  Battle For Zendikar  </option><option value='COMMANDER2015'>  COMMANDER 2015  </option><option value='MAGICORIGINS'>  MAGIC ORIGINS  </option><option value='ModernMasters2015'>  Modern Masters 2015  </option><option value='DRAGONSOFTARKIR'>  DRAGONS OF TARKIR  </option><option value='FATEREFORGED'>  FATE REFORGE  </option><option value='KhansOfTarkir'>  KHANS OF TARKIR  </option><option value='M15'>  Magic 2015  </option><option value='CONSPIRACY'>  CONSPIRACY  </option><option value='JOURNEYINTONYX'>  JOURNEY INTO NYX  </option><option value='BORNOFTHEGODS'>  BORN OF THE GODS  </option><option value='THEROS'>  THEROS  </option><option value='M14'>  Magic 2014  </option><option value='ModernMasters'>  Modern Masters  </option><option value='DragonsMage'>  Dragon's Maze  </option><option value='Gatecrash'>  Gatecrash  </option><option value='ReturntoRavnica'>  Return to Ravnica  </option></select>
<p>language：
<span id="selectCardListLanguage">
<select name="language">
    <option value="English" >English</option>
    <option value="Japanese" selected>日本語</option>
</select></span></p>

<input type="submit" style="font-size:22px;" value="See Card List">
</form>
</center>
<!-- カード一覧終わり -->

</td>

<td width="390" valign="top">
<!--
<b>Sponsored Link</b><br>
<br>
<a href="http://syunakira.com/smd"><img src="./img/koukoku2.jpg" width="250" height="320"></a><br>
-->

    <img src="http://syunakira.com/smd/img/ad/eternal_masters.png">

        <div id="rightSponsoredLink">
			<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
			<!-- 336x280 for SMDS レクタングル大 -->
			<ins class="adsbygoogle"
				 style="display:inline-block;width:336px;height:280px"
				 data-ad-client="ca-pub-2941365993317354"
				 data-ad-slot="8471038462"></ins>
			<script>
			(adsbygoogle = window.adsbygoogle || []).push({});
			</script>

			<br>
			<!-- delete button -->
			<div style="position:relative; top: -2px">
				<center>
				<button onClick="hideSponsoredLink('rightSponsoredLink')" style="padding:1px;">x</button><button disabled style="background-color: #FFFFFF; font-size:10px; padding:0px; border:0px;"> delete this add </button>
				</center>
			</div>
			<!-- end of delete button -->
		</div>

        <!-- Msgic の facebook -->
        <iframe src="https://www.facebook.com/plugins/page.php?href=https%3A%2F%2Fwww.facebook.com%2FMagicTheGathering.jp%2F&tabs=timeline&width=380&height=600&small_header=false&adapt_container_width=true&hide_cover=false&show_facepile=true&appId=187967944930891" width="380" height="600" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowTransparency="true"></iframe>
        <br>

</td></tr></table>

</td>
</tr>
<tr><td>

<table width="1200">
<tr><td>

<center>

	<div id="footerSponsoredLink" style="height:90px;>
		<script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
		<!-- 970x90 for SMDS ビックバナー（大） -->
		<ins class="adsbygoogle"
			 style="display:inline-block;width:970px;height:90px"
			 data-ad-client="ca-pub-2941365993317354"
			 data-ad-slot="5178906868"></ins>
		<script>
		(adsbygoogle = window.adsbygoogle || []).push({});
		</script>

		<br>
		<!-- delete button -->
		<div style="position:relative; top: -28px">
			<center>
			<button onClick="hideSponsoredLink('footerSponsoredLink')" style="padding:1px;">x</button><button disabled style="background-color: #FFFFFF; font-size:10px; padding:0px; border:0px;"> delete this add </button>
			</center>
		</div>
		<!-- end of delete button -->
	</div>

</center>

</td></tr>
<tr><td>
<center>

<a href="http://syunakira.com/smd/">
<img src="http://syunakira.com/smd/img/logotype/DraftSimulator.png"
	onmouseover="this.src='http://syunakira.com/smd/img/logotype/DraftSimulator2.png'"
	onmouseout="this.src='http://syunakira.com/smd/img/logotype/DraftSimulator.png'"
/>
</a>
&nbsp;&nbsp;&nbsp;
<a href="http://syunakira.com/smss/"><img src="http://syunakira.com/smd/img/logotype/SealedSimulator.png"
	onmouseover="this.src='http://syunakira.com/smd/img/logotype/SealedSimulator2.png'"
	onmouseout="this.src='http://syunakira.com/smd/img/logotype/SealedSimulator.png'"
/>
</a>

</center>
</td></tr></table>
</td></tr></table>
</center>


</body>
</html>

<script type="text/javascript" src="toppage.js"></script>

<script type="text/javascript">

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-37984123-1']);
_gaq.push(['_trackPageview']);

(function() {
 var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
 ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
 var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
 })();

</script>