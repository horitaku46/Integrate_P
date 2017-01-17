

// 描画色
public enum StrokeColorType {
    RED,
    BLUE
}


public class Zone6 extends ZumoInfo {
  
  static final float FIRST_START_X = 500.0; // 最初のx軸起点
  static final float FIRST_START_Y = 500.0; // 最初のy軸起点
  private float radius_distance_value = 1.0; // 三角関数の半径
  private float xPrev, yPrev; // 前回の起点
  private int redCount = 0; // 赤色を通過した回数
  
  
  // 画面構成の設定
  @Override
  public void display() {
    // 前描画をリセット
    this.prevDrawReset();
    
    // 座標の生成
    this.setupCoordinate();
    // 座標上に図形認識情報の点をプロット
    this.decidePlotBeginEnd();
  }
  
  
  
  // 座標の生成
  private void setupCoordinate() {
    // 線の色を黒
    stroke(0);
    // 座標軸の生成
    line(300, 500, 1000, 500); // x軸
    line(500, 0, 500, 700); // y軸
  }
  
  
  
  // 赤色を認識し図形描画の制御
  private void decidePlotBeginEnd() {
    
    // 描画色
    StrokeColorType strokeColorType;
    
    // 赤色の通過カウントと描画色の判定
    if ( this.isRed() ) {
      // 描画色を赤色
      strokeColorType = StrokeColorType.RED;
      // 赤色を通過した回数をインクリメント
      this.redCount++;
      // 赤色の場合の半径を設定
      radius_distance_value = 2.5;
      
    } else {
      // 描画色を青色
      strokeColorType = StrokeColorType.BLUE;
      // 青色の場合の半径を設定
      radius_distance_value = 1.0;
    }
    
    if ( zoneNumber_G == 6 && mode_G == 2 && this.redCount < 35 ) {
      //println(this.redCount);
      // 座標上に図形認識情報の点をプロット
      this.plotShapeRecogInfo(strokeColorType);
    }
  }
  
  
  
  // 赤色を認識したらtrueを返す
  private boolean isRed() {
    if ( red_G > 100 && green_G < 100 && blue_G < 100 ) {
      return true;
    } else {
      return false;
    }
  }
  
  
  
  // 座標上に図形認識情報の点をプロット
  // mode_Gが2と3の間がライントレース中
  private void plotShapeRecogInfo(StrokeColorType strokeColorType) {
    
    float rad; // ラジアン
    float xCos, ySin; // 正弦と余弦
    float xPlot, yPlot; // 実際にプロットする値
    
    // ラジアンを算出
    rad = radians(direction_G);
    // 正弦と余弦を算出
    xCos = cos(rad);
    ySin = sin(rad);
    // プロットする座標を算出
    xPlot = xCos * radius_distance_value;
    yPlot = ySin * radius_distance_value;
    
    
    // (0, 0)を原点とする座標軸をスタックに格納
    pushMatrix();
    // 座標軸前回の起点に移動
    translate(xPrev, yPrev);
    
    
    // 点の大きさ
    strokeWeight(8);
    
    // 赤と青の場合で点の色を変更
    switch(strokeColorType) {
    case RED:
      this.strokeRed();
      break;
      
    case BLUE:
      this.strokeBlue();
      break;
      
    default:
      this.strokeBlue();
      break;
    }
    
    // 線を描画
    line(0.0, 0.0, xPlot, yPlot);
    
    // 元の線の太さに
    strokeWeight(1);
    
    
    // 座標軸の位置をスタックから取り出し(0, 0)を設定
    // 以後の処理に影響を与えないため
    popMatrix();
    
    
    // 初回だけ初期の座標値を加算
    if ( xPrev == 0 && yPrev == 0 ) {
      // 前回の座標軸を記憶
      xPrev = FIRST_START_X + xPlot;
      yPrev = FIRST_START_Y + yPlot;
    } else {
      xPrev = xPrev + xPlot;
      yPrev = yPrev + yPlot;
    }
  }
  
  
}