/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package  {
	
	
	public class GameDataXML {
	
		var XMLData:XML;
		
		public function GameDataXML(){
		XMLData= 
<game>
	<tilesize>32</tilesize>
	<screenwidth>480</screenwidth>
	<screenheight>480</screenheight>
	<tilesheetwidth>512</tilesheetwidth>
	<tilesheetheight>640</tilesheetheight>
	<lives>5</lives>
	<score>0</score>
	<level>1</level>
	<numlevels>1</numlevels>
	<dotscore>10</dotscore>
	<erasertile>14</erasertile>
	<playeracceleration>4</playeracceleration>
	<player>
		<lefttile>32</lefttile><lefttile>33</lefttile>
		<righttile>0</righttile><righttile>1</righttile>
		<uptile>36</uptile><uptile>37</uptile>
		<downtile>34</downtile><downtile>35</downtile>
		<uptorighttile>34</uptorighttile><uptorighttile>34</uptorighttile>
		<uptolefttile>34</uptolefttile><uptolefttile>34</uptolefttile>
		<uptodowntile>34</uptodowntile><uptodowntile>34</uptodowntile>
		<downtorighttile>34</downtorighttile><downtorighttile>34</downtorighttile>
		<downtolefttile>34</downtolefttile><downtolefttile>34</downtolefttile>
		<downtouptile>34</downtouptile><downtouptile>34</downtouptile>
		<righttouptile>34</righttouptile><righttouptile>34</righttouptile>
		<righttodowntile>34</righttodowntile><righttodowntile>34</righttodowntile>
		<righttolefttile>34</righttolefttile><righttolefttile>34</righttolefttile>
		<lefttouptile>34</lefttouptile><lefttouptile>34</lefttouptile>
		<lefttodowntile>34</lefttodowntile><lefttodowntile>34</lefttodowntile>
		<lefttorighttile>34</lefttorighttile><lefttorighttile>34</lefttorighttile>
		<levelout>32</levelout><levelout>33</levelout><levelout>0</levelout><levelout>1</levelout>
		<invfilter>73</invfilter><invfilter>74</invfilter><invfilter>75</invfilter><invfilter>76</invfilter>
	</player>
	
	
	<powerup>
		<Title>attack1</Title>
		<type>1</type>
		<playeraccadjust>0</playeraccadjust>
		<playeracctimeadd>0</playeracctimeadd>
		<playerinvincibleadjust>false</playerinvincibleadjust>
		<playerinvincibletimeadd>0</playerinvincibletimeadd>
		<playereatenemyadjust>true</playereatenemyadjust>
		<playereatenemytimeadd>10</playereatenemytimeadd>
		<playerscoreadjust>100</playerscoreadjust>
		<playerbonusadjust>25</playerbonusadjust>
		<playerbonustimeadjust>0</playerbonustimeadjust>
	</powerup>
	
	<powerup>
		<Title>bonusx</Title>
		<type>2</type>
		<playeraccadjust>0</playeraccadjust>
		<playeracctimeadd>0</playeracctimeadd>
		<playerinvincibleadjust>false</playerinvincibleadjust>
		<playerinvincibletimeadd>0</playerinvincibletimeadd>
		<playereatenemyadjust>false</playereatenemyadjust>
		<playereatenemytimeadd>0</playereatenemytimeadd>
		<playerscoreadjust>100</playerscoreadjust>
		<playerbonusadjust>0</playerbonusadjust>
		<playerbonustimeadjust>0</playerbonustimeadjust>
		<playerbonusxadjust>1</playerbonusxadjust>
	</powerup>
	
	<powerup>
		<Title>kill</Title>
		<type>3</type>
		<playeraccadjust>0</playeraccadjust>
		<playeracctimeadd>0</playeracctimeadd>
		<playerinvincibleadjust>false</playerinvincibleadjust>
		<playerinvincibletimeadd>0</playerinvincibletimeadd>
		<playereatenemyadjust>false</playereatenemyadjust>
		<playereatenemytimeadd>0</playereatenemytimeadd>
		<playerscoreadjust>0</playerscoreadjust>
		<playerbonusadjust>0</playerbonusadjust>
		<playerbonustimeadjust>0</playerbonustimeadjust>
		<playerkillallenemyadjust>true</playerkillallenemyadjust>
	</powerup>
	
	
	<powerup>
		<Title>protect</Title>
		<type>4</type>
		<playeraccadjust>0</playeraccadjust>
		<playeracctimeadd>0</playeracctimeadd>
		<playerinvincibleadjust>true</playerinvincibleadjust>
		<playerinvincibletimeadd>10</playerinvincibletimeadd>
		<playereatenemyadjust>false</playereatenemyadjust>
		<playereatenemytimeadd>0</playereatenemytimeadd>
		<playerscoreadjust>100</playerscoreadjust>
		<playerbonusadjust>25</playerbonusadjust>
		<playerbonustimeadjust>0</playerbonustimeadjust>
	</powerup>
	

	
	<powerup>
		<Title>freeze</Title>
		<type>5</type>
		<playeraccadjust>3</playeraccadjust>
		<playeracctimeadd>10</playeracctimeadd>
		<playerinvincibleadjust>false</playerinvincibleadjust>
		<playerinvincibletimeadd>0</playerinvincibletimeadd>
		<playereatenemyadjust>false</playereatenemyadjust>
		<playereatenemytimeadd>0</playereatenemytimeadd>
		<playerscoreadjust>100</playerscoreadjust>
		<playerbonusadjust>25</playerbonusadjust>
		<playerbonustimeadjust>0</playerbonustimeadjust>
	</powerup>
	
	
	
	
	<enemy>
		<Title>dumb1</Title>
		<id>EnemyRat</id>
		<downtile>42</downtile><downtile>43</downtile>
		<uptile>44</uptile><uptile>45</uptile>
		<righttile>30</righttile><righttile>31</righttile>
		<lefttile>46</lefttile><lefttile>47</lefttile>
		<speed>1</speed>
		<intelligence>60</intelligence>
		<score>100</score>
		<fleefilter>80</fleefilter><fleefilter>81</fleefilter><fleefilter>82</fleefilter><fleefilter>83</fleefilter>
	</enemy>
	
	<enemy>
		<Title>dumb2</Title>
		<id>EnemySnakeBlue</id>
		<downtile>59</downtile><downtile>60</downtile>
		<uptile>61</uptile><uptile>62</uptile>
		<righttile>64</righttile><righttile>65</righttile>
		<lefttile>67</lefttile><lefttile>68</lefttile>
		<speed>2</speed>
		<intelligence>70</intelligence>
		<score>200</score>
		<fleefilter>80</fleefilter><fleefilter>81</fleefilter><fleefilter>82</fleefilter><fleefilter>83</fleefilter>
	</enemy>
	
	
	<enemy>
		<Title>smart1</Title>
		<id>EnemyGhost</id>
		<downtile>51</downtile><downtile>52</downtile>
		<righttile>53</righttile><righttile>54</righttile>
		<lefttile>55</lefttile><lefttile>56</lefttile>
		<uptile>57</uptile><uptile>58</uptile>
		<speed>3</speed>
		<intelligence>80</intelligence>
		<score>300</score>
		<fleefilter>80</fleefilter><fleefilter>81</fleefilter><fleefilter>82</fleefilter><fleefilter>83</fleefilter>
	</enemy>
	
	
	
	<enemy>
		<Title>smart2</Title>
		<id>EnemyBat</id>
		<downtile>38</downtile><downtile>39</downtile><downtile>40</downtile><downtile>41</downtile>
		<righttile>38</righttile><righttile>39</righttile><righttile>40</righttile><righttile>41</righttile>
		<lefttile>38</lefttile><lefttile>39</lefttile><lefttile>40</lefttile><lefttile>41</lefttile>
		<uptile>38</uptile><uptile>39</uptile><uptile>40</uptile><uptile>41</uptile>
		<speed>4</speed>
		<intelligence>90</intelligence>
		<score>400</score>
		<fleefilter>80</fleefilter><fleefilter>81</fleefilter><fleefilter>82</fleefilter><fleefilter>83</fleefilter>
	</enemy>

	
	<explosion>
	<id>EnemyEat</id>
	<tile>68</tile><tile>69</tile><tile>70</tile><tile>71</tile><tile>72</tile>
	</explosion>
	

</game>;
	
		}

	public function getXML():XML {
			return XMLData;
		}
		
	} // end class
}// end package