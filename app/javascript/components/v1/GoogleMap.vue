<script setup lang="ts">
// import { usePage } from '@inertiajs/vue3';
import { useRamenStore } from '@/stores/ramenStore';
import { onMounted, ref } from 'vue';
import { watch } from 'vue';
import { useDarkModeStore } from '@/stores/isDarkMode';
import { Ref } from 'vue';

// import { details } from '@/stores/dummyData.js';//ダミーデータ

(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})
({key: "myApiKey", v: "beta"});

let map: google.maps.Map;
let infoWindow: google.maps.InfoWindow;
let service: google.maps.places.PlacesService;
let mapStyle: Ref<string> = ref('');//グーグルマップスタイル
let markers: any = [];//マーカー配列

const props: {
    readonly googleMaps: string;
  } = defineProps({
  googleMaps: {type: String, default: null}
});

const MapsMode = useDarkModeStore();//ページのスタイル
const station: Ref<boolean, boolean> = ref(false);//駅検索モーダル
const ramenStore = useRamenStore();

//初期処理
const initMap: () => Promise<void> = async () => {
  const position = { lat: -25.344, lng: 131.031 };
  const { Map } = await google.maps.importLibrary("maps") as google.maps.MapsLibrary;
  const { PlacesService } = await google.maps.importLibrary("places") as google.maps.PlacesLibrary;

  //マップ読み込み
  map = new Map(document.getElementById("map") as HTMLElement, {
    zoom: 15,
    center: position,
    //マップスタイル
    mapId: mapStyle.value,
    mapTypeControl: false,
    streetViewControl: false,
    fullscreenControl: false,
  });

  //インスタンス化
  infoWindow = new google.maps.InfoWindow();
  service = new PlacesService(map);
}

//現在地取得処理
const getCurrentlocation: () => Promise<void> = async () => {
  if (navigator.geolocation) {
    try {
      const position = await new Promise<GeolocationPosition>((resolve, reject) => {
        navigator.geolocation.getCurrentPosition(resolve, reject);
      });

      const pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      };

      // 遷移アニメーション
      map.panTo(pos);
      infoWindow.setPosition(pos);
      infoWindow.setContent("現在地");
      infoWindow.open(map);
    } catch(error) {
      //エラー処理
      handleLocationError(true, infoWindow);
      console.log(error);
    };
  } else {
    //ブラウザが位置情報をサポートしていない場合
    alert("ブラウザは位置情報をサポートしていません");
  }
};

//ラーメン屋情報取得処理 //flgの型を後で調べる
const findRamenNearby: (flg: any) => Promise<void> = async (flg) => {
  //マーカーをリセット
  for(let marker of markers){
    marker.setMap(null);
  }
  markers = [];
  if (!flg) {
    const bounds = map.getBounds();
    const request: google.maps.places.PlaceSearchRequest = {
      bounds: bounds,//画面内を検索
      type: 'restaurant', // レストランを検索
      keyword: 'ramen' // キーワードはラーメン
    };
  
    service.nearbySearch(request, async (results, status) => {
      if (status === google.maps.places.PlacesServiceStatus.OK && results) {
        // 各検索結果の詳細情報を取得するPromiseの配列を作成
        const detailsPromises = results.map(results =>
          new Promise((resolve, reject) => {
            if(results.place_id) {
              service.getDetails({placeId: results.place_id, fields: ['name', 'geometry', 'place_id']}, (detail, status) => {
                if(status === google.maps.places.PlacesServiceStatus.OK) {
                  resolve(detail);
                }else{
                  reject('Detail fetch failed');
                }
              });
            }
          })
        );
        try{
          const details = await Promise.all(detailsPromises);
          ramenStore.ramenShops = details;//グローバルステイトへ保存
          details.forEach(detail => createMarker(detail));
        }catch (error) {
          console.error(error);
            infoWindow.setPosition(map.getCenter());
            infoWindow.setContent('ラーメン屋の詳細情報の取得に失敗しました');
            infoWindow.open(map);
        }
      } else {
        infoWindow.setPosition(map.getCenter());
        infoWindow.setContent('ラーメン屋が見つかりませんでした');
        infoWindow.open(map);
      }
    });

    // //ダミーデータ
    // const dummydetails = details;
    // ramenStore.ramenShops = dummydetails;//グローバルステイトへ保存
    // dummydetails.forEach(detail => createMarker(detail));
  } else {
    //お気に入りからのアクセスの場合
    if(service) {
      service.getDetails({placeId: flg, fields: ['name', 'geometry', 'place_id']}, (detail, status) => {
        if(status === google.maps.places.PlacesServiceStatus.OK) {
          ramenStore.ramenShops = [detail];//配列に変換しグローバルステイとへ保存
          //お気に入り店舗へ画面遷移＆マーカー設置
          if(detail && detail.geometry && detail.geometry.location) {
            const setposition: google.maps.LatLng | google.maps.LatLngLiteral = detail.geometry.location;
            map.setCenter(setposition);
          }
          map.setZoom(15);
          createMarker(detail);
        } else {
          alert('スタッツエラーが発生しました');
        }
      });
    } else {
      alert("サービスエラーが発生しました");
    }
  }
}

//マーカー作成処理
const createMarker: (place: any) => Promise<void> = async place => {
  const {AdvancedMarkerElement} = await google.maps.importLibrary("marker") as google.maps.MarkerLibrary;
  //カスタムマーカー
  const parser = new DOMParser();
  const pinSvgString =
  `<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 512 512" xml:space="preserve" class="fill-red-500 w-8 h-2/3"><path class="st0" d="M316.766,60.625c0-7.953-6.453-14.406-14.406-14.406c-7.969,0-14.406,6.453-14.406,14.406v7.109h-24.188v-7.109c0-7.953-6.453-14.406-14.391-14.406c-7.969,0-14.422,6.453-14.422,14.406v7.109h-24.172v-7.109c0-7.953-6.438-14.406-14.406-14.406c-7.953,0-14.406,6.453-14.406,14.406v7.109h-44.484v30.797l44.484,1.125v116H2.828v16.469c-0.016,62.688,24.391,121.594,68.719,165.891c22.828,22.828,49.547,40.406,79.453,52.266V512h172.859v-61.719c29.922-11.859,56.641-29.438,79.453-52.266c44.328-44.297,68.719-103.203,68.719-165.891v-16.469H316.766V103.125l192.406,4.938V67.734H316.766V60.625z M210.781,100.406l24.172,0.625v114.625h-24.172V100.406z M295.047,483.188H179.813v-27.844c18.422,4.75,37.719,7.281,57.625,7.266c19.875,0.016,39.188-2.516,57.609-7.266V483.188z M382.953,377.641c-37.297,37.266-88.656,60.266-145.516,60.266c-56.875,0-108.25-23-145.531-60.266c-34.531-34.563-56.813-81.234-59.891-133.172h410.828C439.781,296.406,417.5,343.078,382.953,377.641z M287.953,215.656h-24.188V101.766l24.188,0.625V215.656z"></path></svg>`;
  const pinSvgElement = parser.parseFromString(
    pinSvgString,
    "image/svg+xml"
  ).documentElement;

  if (!place.geometry || !place.geometry.location) return;
  const marker = new AdvancedMarkerElement({
    map,
    position: place.geometry.location,
    content: pinSvgElement,
  });
  markers.push(marker);

  //マーカークリック時カード遷移
  google.maps.event.addListener(marker, 'click', () => {
    handleMarkerClick(place);
  });
}

//駅検索処理
const stationModal: () => Promise<void> = async () => {
  const { Autocomplete } = await google.maps.importLibrary("places") as google.maps.PlacesLibrary;
  const input = document.getElementById('pac-input') as HTMLInputElement;
  const autocomplete = new Autocomplete(input, {
    types: ['subway_station', 'train_station', 'transit_station'],
    fields: ['geometry', 'name'],
  });

  autocomplete.addListener('place_changed', () => {
    const place = autocomplete.getPlace();
    if (!place.geometry || !place.geometry.location){
      console.log('指定された名前の駅は存在しません');
      return;
    }

    const stationlocation = place.geometry.location;
    map.setCenter(stationlocation);
    map.setZoom(15);

    createMarker(place);

    // 駅名を表示するインフォウィンドウを開く
    infoWindow.setContent(place.name);
    infoWindow.open(map, markers);

    // モーダルを閉じる
    station.value = false;
  });
};

//カード遷移処理
const handleMarkerClick: (place: any) => void = place => {
  if (place) {
    //クリック時カードに遷移
    const shopElement = document.getElementById(`shop-${place.place_id}`);
    if(shopElement){
      shopElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
      shopElement.style.zIndex = '1000';
      //カード強調表示
      if(document.documentElement.classList.contains('dark')){
        shopElement.style.backgroundColor = '#1d4ed8';
      }else{
      //ダークモードへ変更
        shopElement.style.backgroundColor = '#ffcc00';
      }
      shopElement.style.transition = 'background-color 0.5s ease';
      setTimeout(() => {
        shopElement.style.backgroundColor = '';
        shopElement.style.zIndex = '';
      }, 1000);
    }
  }else{
    infoWindow.setContent('店舗情報が取得出来ませんでした。');
  }
}

//エラー処理
const handleLocationError: (browserHasGeolocation: boolean, infoWindow: google.maps.InfoWindow) => void = (
  browserHasGeolocation, infoWindow
) => {
  infoWindow.setPosition(map.getCenter());
  infoWindow.setContent(
    browserHasGeolocation
      ? "Error: The Geolocation service failed."
      : "Error: Your browser doesn't support geolocation."
  );
  infoWindow.open(map);
}

//$refsメソッド
defineExpose({
  findRamenNearby,
});

//各メソッドを実行
onMounted( async () => {
  //初期処理実行
  await initMap();
  //駅検索ウィンドウのオートコンプリートを実行
  await stationModal();
  //お気に入りからの場合
  if(props.googleMaps) {
    await findRamenNearby(props.googleMaps);
  } else {
    //ロード時現在地へ
    await getCurrentlocation();
  }
});

//初期化時にローカルストレージの値を確認
onMounted(() => {
  if (localStorage.theme === 'dark') {
    mapStyle.value = "a6388723669eb9cc";
  } else {
    mapStyle.value = "DEMO_MAP_ID";
  }
})

//グーグルマップのダークモード切替処理
watch(MapsMode, (newValue) => {
  if(newValue.isDarkMode === true){
    mapStyle.value = "a6388723669eb9cc";
    initMap();
    getCurrentlocation();
  }else{
    mapStyle.value = "DEMO_MAP_ID";
    initMap();
    getCurrentlocation();
  }
});

//駅検索モーダル起動時スクロール無効化
watch(station, (newValue) => {
  if (newValue) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
});
</script>

<template>
  <div>
    <div id="map" class=""></div>
    <!-- クリック時駅検索モーダル起動 -->
    <button id="search-station" class="bg-white transition duration-700 hover:bg-blue-400 shadow-md w-10 h-10 rounded-sm m-2.5 absolute top-[377px] right-0"
    @click="station = !station"
    >
      <svg viewBox="0 0 51 53" xmlns="http://www.w3.org/2000/svg" class="fill-blue-500 w-full h-2/3">
        <path d="M49.3595 13.3609H46.9523V6.8985C46.9523 5.18457 46.1952 3.54083 44.8476 2.32889C43.5 1.11695 41.6723 0.436096 39.7665 0.436096L11.0233 0.436096C9.11753 0.436096 7.2898 1.11695 5.9422 2.32889C4.5946 3.54083 3.83753 5.18457 3.83753 6.8985V13.3609H1.39436C1.08943 13.3609 0.796992 13.4698 0.581376 13.6638C0.36576 13.8577 0.244629 14.1207 0.244629 14.3949V22.0205C0.244629 22.5925 0.758413 23.0545 1.39436 23.0545H3.83753V42.4417C3.83753 44.2189 3.83753 45.6729 7.43042 45.6729V50.5197C7.43042 50.9482 7.61969 51.3592 7.95659 51.6621C8.29349 51.9651 8.75043 52.1353 9.22687 52.1353H16.4127C16.8891 52.1353 17.3461 51.9651 17.683 51.6621C18.0198 51.3592 18.2091 50.9482 18.2091 50.5197V45.6729H32.5807V50.5197C32.5807 50.9482 32.77 51.3592 33.1069 51.6621C33.4438 51.9651 33.9007 52.1353 34.3772 52.1353H41.563C42.0394 52.1353 42.4963 51.9651 42.8332 51.6621C43.1701 51.3592 43.3594 50.9482 43.3594 50.5197V45.6729C46.9523 45.6729 46.9523 44.2189 46.9523 42.4417V23.0545H49.3595C49.674 23.0545 49.9756 22.9422 50.1979 22.7422C50.4203 22.5422 50.5452 22.271 50.5452 21.9882C50.5452 21.7054 50.4203 21.4342 50.1979 21.2342C49.9756 21.0343 49.674 20.9219 49.3595 20.9219C49.0451 20.9219 48.7435 21.0343 48.5212 21.2342C48.2988 21.4342 48.1739 21.7054 48.1739 21.9882C48.1739 22.271 48.2988 22.5422 48.5212 22.7422C48.7435 22.9422 49.0451 23.0545 49.3595 23.0545C49.674 23.0545 49.9756 22.9422 50.1979 22.7422C50.4203 22.5422 50.5452 22.271 50.5452 21.9882V14.4272C50.5452 14.1444 50.4203 13.8732 50.1979 13.6732C49.9756 13.4732 49.674 13.3609 49.3595 13.3609ZM18.2091 3.6673H32.5807V6.8985H18.2091V3.6673ZM11.0233 39.2105C10.0704 39.2105 9.15656 38.8701 8.48276 38.2641C7.80896 37.6582 7.43042 36.8363 7.43042 35.9793C7.43042 35.1224 7.80896 34.3005 8.48276 33.6945C9.15656 33.0886 10.0704 32.7481 11.0233 32.7481C11.9762 32.7481 12.8901 33.0886 13.5639 33.6945C14.2377 34.3005 14.6162 35.1224 14.6162 35.9793C14.6162 36.8363 14.2377 37.6582 13.5639 38.2641C12.8901 38.8701 11.9762 39.2105 11.0233 39.2105ZM7.43042 26.2857V10.1297H43.3594V26.2857H7.43042ZM39.7665 39.2105C38.8136 39.2105 37.8997 38.8701 37.2259 38.2641C36.5521 37.6582 36.1736 36.8363 36.1736 35.9793C36.1736 35.1224 36.5521 34.3005 37.2259 33.6945C37.8997 33.0886 38.8136 32.7481 39.7665 32.7481C40.7194 32.7481 41.6333 33.0886 42.3071 33.6945C42.9809 34.3005 43.3594 35.1224 43.3594 35.9793C43.3594 36.8363 42.9809 37.6582 42.3071 38.2641C41.6333 38.8701 40.7194 39.2105 39.7665 39.2105Z"/>
      </svg>
    </button>
    <!-- 駅検索モーダル -->
    <div class="flex justify-center">
      <div id="modal"
      class="fixed -translate-y-40 top-0 duration-700 z-60 opacity-0 rounded-lg bg-white px-5 pt-6 pb-5 sm:max-w-md sm:w-full sm:p-6 flex justify-between" 
      :class="{
      'opacity-100':station,
      'translate-y-40':station,
      }">
        <input id="pac-input" class="controls w-2/3" type="text" placeholder="Search Box"/>
        <div id="infowindow-content">
          <span id="place-name" class="title"></span><br />
        </div>
        <button @click="stationModal">検索</button>
        <button id="close-btn" class="text-4xl absolute -top-2 right-1" @click="station = !station">×</button>
      </div>
    </div>
    <!--クリック時現在地へ遷移-->
    <button id="current-btn" class="bg-white transition duration-700 hover:bg-red-400 shadow-md w-10 h-10 rounded-sm m-2.5 absolute top-[430px] right-0"
    @click="getCurrentlocation"
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="fill-red-500 w-full h-2/3">
        <path fill-rule="evenodd" d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-1.99 3.963-4.98 3.963-8.827a8.25 8.25 0 0 0-16.5 0c0 3.846 2.02 6.837 3.963 8.827a19.58 19.58 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.145.742ZM12 13.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />
      </svg>
    </button>
    <!--クリック時ラーメン屋表示-->
    <button id="ramen-search" class="bg-white transition duration-700 hover:bg-green-400 shadow-md w-10 h-10 rounded-sm m-2.5 absolute top-[325px] right-0" 
    @click="findRamenNearby(null)"
    >
      <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 512 512" xml:space="preserve" class="fill-green-500 w-full h-2/3">
          <path class="st0" d="M316.766,60.625c0-7.953-6.453-14.406-14.406-14.406c-7.969,0-14.406,6.453-14.406,14.406v7.109h-24.188v-7.109c0-7.953-6.453-14.406-14.391-14.406c-7.969,0-14.422,6.453-14.422,14.406v7.109h-24.172v-7.109c0-7.953-6.438-14.406-14.406-14.406c-7.953,0-14.406,6.453-14.406,14.406v7.109h-44.484v30.797l44.484,1.125v116H2.828v16.469c-0.016,62.688,24.391,121.594,68.719,165.891c22.828,22.828,49.547,40.406,79.453,52.266V512h172.859v-61.719c29.922-11.859,56.641-29.438,79.453-52.266c44.328-44.297,68.719-103.203,68.719-165.891v-16.469H316.766V103.125l192.406,4.938V67.734H316.766V60.625z M210.781,100.406l24.172,0.625v114.625h-24.172V100.406z M295.047,483.188H179.813v-27.844c18.422,4.75,37.719,7.281,57.625,7.266c19.875,0.016,39.188-2.516,57.609-7.266V483.188z M382.953,377.641c-37.297,37.266-88.656,60.266-145.516,60.266c-56.875,0-108.25-23-145.531-60.266c-34.531-34.563-56.813-81.234-59.891-133.172h410.828C439.781,296.406,417.5,343.078,382.953,377.641z M287.953,215.656h-24.188V101.766l24.188,0.625V215.656z"></path>
      </svg>
    </button>
    <div id="z-black" @click="station = !station" class="fixed w-full invisible duration-700 top-0" 
    :class="{'bgaction':station}"></div>
  </div>
</template>

<style scoped>
#map {
  height: 600px; /* マップの高さを指定 */
  width: 100%; /* マップの幅を指定 */
}
/* メニュー背景 */
#z-black.bgaction{
  height: 100%;
  visibility: visible;
  background: rgba(0,0,0,0.4);
  z-index: 55;
}
</style>