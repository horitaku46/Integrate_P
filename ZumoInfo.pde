

public final class ZoneInfoConst {
  // 描画するテキストの表示Y軸
  static final int TEXT_START_Y_POS = 210;
  // 描画するテキストサイズ
  static final int TEXT_SIZE = 18;
  // テキスト間隔値
  static final int INFO_GAP_TEXT_VALUE = 30;
  // 情報名の左端X軸
  static final int INFO_NAME_LEFT_X = 80;
  // 情報値の右端X軸
  static final int INFO_NAME_RIGHT_X = 82;
}


public enum ZumoInfoType {
  // ゾーンナンバー
  ZONE_NUMBER,
  // モード
  MODE,
  // 経過時間
  MS_TIME,
  // Zumoの方角
  DIRECTION
}


public class ZumoInfo extends ExtensionMethods {
  
  // 各ゾーンにドットするXY軸(Zone1からZone6まで)
  private int[][] redDotPlotPosArray = {{58, 50}, {142, 50}, {237, 60}, {237, 155}, {146, 155}, {63, 155}};
  // 描画する情報配列
  private String[] infoNameArray = {"ゾーン名", "モード", "経過時間", "方角"};
  
  // ゾーン全体画像
  private PImage zoneImage;
  // 方角を表すZumo画像
  private PImage zumoImage;
  // 方角を表す表画像
  private PImage directionImage;
  
  
  
  // コンストラクタ
  public ZumoInfo() {
    // 全体ゾーン画像の読み込み
    this.zoneImage = loadImage("./Resource/zone.png");
    // 方角を表すZumo画像の読み込み
    this.zumoImage = loadImage("./Resource/zumo.png");
    // 方角を表す表画像読み込み
    this.directionImage = loadImage("./Resource/direction.png");
  }
  
  
  
  // 更新値を描画
  protected void display() {
    // Zumo情報画面のリセット
    this.resetInfoView();
    
    // Zone上の位置表示
    this.drawWhereZone();
    
    // Zumoの情報を描画
    this.drawInfoText();
    
    // Zumoの方角を描画
    this.drawZumoDirection();
  }
  
  
  
  // Zumo情報画面のリセット
  private void resetInfoView() {
    // 値を表示する領域だけ重なりを発生させない処理
    fill(255); // 背景を白
    stroke(255); // 領域の枠線を白
    rect(0, 0, 300, 700); // 領域
    
    stroke(0); // 仕切りの色を黒
    line(300, 0, 300, 700); // しきり線
  }
  
  
  
  // Zone上の位置表示
  private void drawWhereZone() {
    // ゾーン全体画像の描画
    image(this.zoneImage, 0, 0);
    
    try {
      // スタートとゴールは表示しない
      if ( zoneNumber_G != 0 && zoneNumber_G != 7 ) {
        // 点の大きさ
        strokeWeight(50);
        // 点の色を赤
        this.strokeRed();
        // 点をプロット
        point(this.redDotPlotPosArray[zoneNumber_G - 1][0], this.redDotPlotPosArray[zoneNumber_G - 1][1]);
        // 元の点の大きさに戻す
        strokeWeight(1);
      }
      
    } catch(ArrayIndexOutOfBoundsException error) {
      // 元の点の大きさに戻す
      strokeWeight(1);
      println(error);
    }
  }
  
  
  
  // Zumoの情報を描画
  private void drawInfoText() {
    // 日本語化
    this.localizationJaText();
    
    // 文字の大きさ
    textSize(ZoneInfoConst.TEXT_SIZE);
    
    // 各情報名と値を描画
    for (int index = 0; index < this.infoNameArray.length; index++) {
      // 各項目のY軸
      int yPos = ZoneInfoConst.INFO_GAP_TEXT_VALUE * (index + 1) + ZoneInfoConst.TEXT_START_Y_POS;
      
      // 情報名を右揃え
      textAlign(RIGHT);
      // 文字色は赤
      this.fillRed();
      // 情報名を描画
      text(this.infoNameArray[index] + ":", ZoneInfoConst.INFO_NAME_LEFT_X, yPos);
      
      // 情報値を左揃え
      textAlign(LEFT);
      // 文字色は黒
      fill(0);
      // 各項目の設定
      if ( index == ZumoInfoType.ZONE_NUMBER.ordinal() ) {
        String zoneName = this.zoneName();
        text(zoneName, ZoneInfoConst.INFO_NAME_RIGHT_X, yPos);
        
      } else if ( index == ZumoInfoType.MODE.ordinal() ) {
        text(mode_G, ZoneInfoConst.INFO_NAME_RIGHT_X, yPos);
        
      } else if ( index == ZumoInfoType.MS_TIME.ordinal() ) {
        String time = this.makeDegitalTime(sec_G);
        text(time, ZoneInfoConst.INFO_NAME_RIGHT_X, yPos);
        
      } else if ( index == ZumoInfoType.DIRECTION.ordinal() ) {
        String dirName = this.makeDirectionName();
        text(dirName, ZoneInfoConst.INFO_NAME_RIGHT_X, yPos);
      }
    }
  }
  
  
  
  // ゾーン名を返す
  private String zoneName() {
    switch( zoneNumber_G ) {
    case 0:
      return "移動中";
    case 1:
      return "ミュージックプレイゾーン";
    case 2:
      return "宝集めゾーン";
    case 3:
      return "山登らずゾーン";
    case 4:
      return "アイテムグラバーゾーン";
    case 5:
      return "棒倒しゾーン";
    case 6:
      return "図形認識ゾーン";
    case 7:
      return "ゴール";
    default:
      return "";
    }
  }
  
  
  
  // 秒数をデジタル時計で返す
  private String makeDegitalTime(int sec) {
    // 分
    int m = sec / 60;
    // 秒
    int s = sec % 60;
    return String.format("%02d", m)+ ":" + String.format("%02d", s);
  }
  
  
  
  // 数値から方角を返す
  private String makeDirectionName() {
    if ( 337 <= direction_G || direction_G < 22 ) { // 北
      return "北";
    } else if ( 22 <= direction_G && direction_G < 67 ) { // 北東
      return "北東";
    } else if ( 67 <= direction_G && direction_G < 112 ) { // 東
      return "東";
    } else if ( 112 <= direction_G && direction_G < 157 ) { // 南東
      return "南東";
    } else if ( 157 <= direction_G && direction_G < 202 ) { // 南
      return "南";
    } else if ( 202 <= direction_G && direction_G < 247 ) { // 南西
      return "南西";
    } else if ( 247 <= direction_G && direction_G < 292 ) { // 西
      return "西";  
    } else if ( 292 <= direction_G && direction_G < 337 ) { // 北西
      return "北西";
    } else {
      return "";
    }
  }
  
  
  
  // Zumoの方角を描画
  private void drawZumoDirection() {
    // 方角を表す表画像を描画
    image(this.directionImage, 0.0, 400.0);
    
    // (0, 0)を原点とする座標軸をスタックに格納
    pushMatrix();
    
    // 画像中央を回転の中心にする
    translate(150, 550);
    
    // 方角の方向に回転
    rotate(radians(direction_G));
       
    // 回転の中心が画像中央なので、画像描画原点も画像中央にする
    // こうすると(0,0)に配置すれば期待した位置に画像が置ける
    imageMode(CENTER);
       
    // 方角を表すZumo画像
    image(this.zumoImage, 0, 0);
       
    // 画像描画原点を元（画像の左上隅）に戻す
    imageMode(CORNER);
    
    // 座標軸の位置をスタックから取り出し(0, 0)を設定
    // 以後の処理に影響を与えないため
    popMatrix();
  }
  
  
}



// 拡張メソッドクラス
public class ExtensionMethods {
  
  // 各ゾーンでの前描画をリセットフラグ
  public boolean isResetView = true;
  
  
  // 各ゾーンでの前描画をリセット処理
  public void prevDrawReset() {
    if ( this.isResetView ) {
      this.resetZoneView();
      this.isResetView = false;
    }
  }
  
  // 各ゾーン図形描画での更新処理(毎回背景を白色に)
  public void resetZoneView() {
    // 値を表示する領域だけ重なりを発生させない処理
    fill(255); // 背景を白
    stroke(255); // 領域の枠線を白
    rect(301, 0, 1000, 700); // 領域
  }
  
  // 日本語化
  public void localizationJaText() {
    PFont font = createFont("MS Gothic", 20, true);
    textFont(font);
  }
  
  // 文字の色を赤に
  public void fillRed() {
    fill(255, 0, 0);
  }
  
  // 線や点の色を赤に
  public void strokeRed() {
    stroke(255, 0, 0);
  }
  
  // 線や点の色を青に
  public void strokeBlue() {
    stroke(0, 0, 255);
  }
  
  
}