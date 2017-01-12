import processing.serial.*;


public final class SettingConst {
  
  // Takuma's Zumo
  static final String SERIAL_COM_PORT = "/dev/cu.usbserial-A90177AF";
  // Ozaki's Zumo
  //static final String SERIAL_COM_PORT = "/dev/cu.usbserial-A90174UN";
  
  // フレームレート数
  static final int FRAMERATE = 60;
  // 通信速度(bps)
  static final int SERIAL_COM_BAUND_RATE = 9600;
  // ウィンドウの横幅
  static final int WINDOW_MAIN_X = 1000;
  // ウィンドウの縦幅
  static final int WINDOW_MAIN_Y = 700;
}


int zoneNumber_G, mode_G;
int sec_G; // 経過時間（秒）
int max_r_G, max_g_G, max_b_G, min_r_G, min_g_G, min_b_G; // RGBキャリブレーション値
float max_x_G, max_y_G, min_x_G, min_y_G; // 地磁気センサキャリブレーション値
int red_G, green_G, blue_G; // RGB
float direction_G; // Zumoの方向（0~360）

// Zone4
int detectColor_G; // ポイントで検知した色


Serial port;
ZumoInfo zumoInfo;
Zone4 zone4;
Zone6 zone6;


// 初期設定
void settings() {
  // 画面生成
  size(SettingConst.WINDOW_MAIN_X, SettingConst.WINDOW_MAIN_Y);
}



// 設定
void setup() {
  // 背景を白
  background(255);
  // draw()を1秒間に60回呼び出す(デフォルト 60)
  frameRate(SettingConst.FRAMERATE);
  
  // シリアルポートの設定
  //port = new Serial(this, SettingConst.SERIAL_COM_PORT, SettingConst.SERIAL_COM_BAUND_RATE);
  
  // 各オブジェクトの生成.
  zumoInfo = new ZumoInfo();
  zone4 = new Zone4();
  zone6 = new Zone6();
}



// 描画関数
void draw() {
  // 再現用のテストデータを更新
  updateTestData();
  
  // Zumo情報の描画
  zumoInfo.display();
  
  
  // ゾーンにより描画切り替え
  switch ( zoneNumber_G ) {
  case 0:
    break; // ゾーンからゾーンの移動
  
  case 1:
    break; // ミュージックプレイゾーン
  
  case 2:
    break; // 宝集めゾーン
  
  case 3:
    break; // 山登らずゾーン
  
  case 4:
    zone4.display(); // アイテムグラバーゾーン
    break;
  
  case 5:
    break; // 棒倒しゾーン
  
  case 6:
    zone6.display(); // 図形認識ゾーン
    break;
  
  case 7:
    break; // フィニッシュアクション
  
  default:
    break;
  }
}



// 動きを再現するためのテストデータ関数
boolean isIncZoneNumber = false;
void updateTestData() {
  // テストセッティング
  mode_G = 2;
  
  // テストタイム
  sec_G = millis() / 1000;
  
  // 5秒ごとにゾーンナンバーをインクリメント
  if ( isIncZoneNumber && sec_G % 5 == 0 ) {
    zoneNumber_G++;
    if ( zoneNumber_G == 7 ) {
      // draw関数の停止
      noLoop();
    }
    // 方向値を初期化
    direction_G = 0;
    isIncZoneNumber = false;
  } else if ( !isIncZoneNumber && sec_G % 5 == 4 ) {
    isIncZoneNumber = true;
  }
  
  // 方向を360までインクリメント
  if ( direction_G < 360 ) {
    direction_G++;
  } else if ( direction_G == 360 ) {
    direction_G = 0;
  }
  
  // Zumoの方向に乱数を代入
  //direction_G = (int)random(360.0);
  
  // RGB値に乱数を代入
  red_G = (int)random(255.0);
  green_G = (int)random(255.0);
  blue_G = (int)random(255.0);
  
  // ポイントで検知した色に乱数を代入
  detectColor_G = (int)random(5.0);
}



// RGB値を255までマッピング
int mapRGB(int rgb) {
  return (int)map(rgb, 0, 100, 0, 255);
} //<>//



// Arduinoから受信する関数
void serialEvent(Serial p) {
  
  int h, l, d;
  
  // 受け取れるデータの個数
  if ( p.available() >= 30 ) {
    if ( p.read() == 'H' ) {
      
      zoneNumber_G = p.read();
      mode_G = p.read();
      sec_G = p.read();
      
      // カラーセンサのキャリブレーション値
      h = p.read();
      l = p.read();
      max_r_G = (int)((h << 8) + l);
      if ( max_r_G > 32767 ) {
        max_r_G -= 65536;
      }
      h = p.read();
      l = p.read();
      max_g_G = (int)((h << 8) + l);
      if ( max_g_G > 32767 ) {
        max_g_G -= 65536;
      }
      h = p.read();
      l = p.read(); 
      max_b_G = (int)((h << 8) + l);
      if ( max_b_G > 32767 ) {
        max_b_G -= 65536;
      }
      h = p.read();
      l = p.read(); 
      min_r_G = (int)((h << 8) + l);
      if ( min_r_G > 32767 ) {
        min_r_G -= 65536;
      }
      h = p.read();
      l = p.read(); 
      min_g_G = (int)((h << 8) + l);
      if ( min_g_G > 32767 ) {
        min_g_G -= 65536;
      }
      h = p.read();
      l = p.read(); 
      min_b_G = (int)((h << 8) + l);
      if ( min_b_G > 32767 ) {
        min_b_G -= 65536;
      }
      
      // 地磁気センサのキャリブレーション値
      h = p.read();
      l = p.read(); 
      d = (h << 8) + l;
      if ( d > 32767 ) {
        d -= 65536;
      }
      max_x_G = (float)d / 100.0;
      h = p.read(); 
      l = p.read();
      d = (h << 8) + l;
      if ( d > 32767 ) {
        d -= 65536;
      }
      max_y_G = (float)d / 100.0;
      h = p.read(); 
      l = p.read();
      d = (h << 8) + l;
      if ( d > 32767 ) {
        d -= 65536;
      }
      min_x_G = (float)d / 100.0;
      h = p.read();
      l = p.read();
      d = (h << 8) + l;
      if ( d > 32767 ) {
        d -= 65536;
      }
      min_y_G = (float)d / 100.0;
      
      // RGB(255まで)
      red_G = mapRGB(p.read());
      green_G = mapRGB(p.read());
      blue_G = mapRGB(p.read());
      
      // Zumoの方向
      h = p.read();
      l = p.read();
      d = (h << 8) + l;
      if ( d > 32767 ) {
        d -= 65536;
      }
      direction_G = (float)d / 100.0;
      
      // Zone4でのポイントで検知した色
      detectColor_G = p.read();
      
      //print("zone = ");
      //println(zoneNumber_G, mode_G);
      
      //print("TIME = ");
      //println(sec);
      
      //print("max_r, max_g, max_b, min_r, min_g, min_b = ");
      //println(max_r_G, max_g_G, max_b_G, min_r_G, min_g_G, min_b_G);
      
      //print("max_x, max_y, min_x, min_y = ");
      //println(max_x_G, max_y_G, min_x_G, min_y_G);
      
      //print("RGB = ");
      //println(red_G, green_G, blue_G);
      
      //print("SPEED(LEFT,RIGHT) = ");
      //println(motorL_G, motorR_G);
      
      //print("DIRECTION = ");
      //println(direction_G);
      
      // 念のためクリア
      p.clear();
    }
  }
}