$csharpCode = @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

public class ImageCleaner {
    public static void Process(string srcPath, string destPath) {
        using (Bitmap src = new Bitmap(srcPath)) {
            int w = src.Width;
            int h = src.Height;
            Bitmap res = new Bitmap(w, h, PixelFormat.Format32bppArgb);
            bool[,] visited = new bool[w, h];
            Queue<Point> q = new Queue<Point>();

            bool IsBg(Color c) {
                int diffRG = Math.Abs(c.R - c.G);
                int diffGB = Math.Abs(c.G - c.B);
                int diffRB = Math.Abs(c.R - c.B);
                return (c.R >= 195 && c.G >= 195 && c.B >= 195 && diffRG <= 10 && diffGB <= 10 && diffRB <= 10);
            }

            for (int x = 0; x < w; x++) {
                if (IsBg(src.GetPixel(x, 0))) { q.Enqueue(new Point(x, 0)); visited[x, 0] = true; }
                if (IsBg(src.GetPixel(x, h - 1))) { q.Enqueue(new Point(x, h - 1)); visited[x, h - 1] = true; }
            }
            for (int y = 0; y < h; y++) {
                if (IsBg(src.GetPixel(0, y))) { q.Enqueue(new Point(0, y)); visited[0, y] = true; }
                if (IsBg(src.GetPixel(w - 1, y))) { q.Enqueue(new Point(w - 1, y)); visited[w - 1, y] = true; }
            }

            int[] dx = { 1, -1, 0, 0, 1, 1, -1, -1 };
            int[] dy = { 0, 0, 1, -1, 1, -1, 1, -1 };

            while (q.Count > 0) {
                Point p = q.Dequeue();
                for (int i = 0; i < 8; i++) {
                    int nx = p.X + dx[i];
                    int ny = p.Y + dy[i];
                    if (nx >= 0 && nx < w && ny >= 0 && ny < h && !visited[nx, ny]) {
                        if (IsBg(src.GetPixel(nx, ny))) {
                            visited[nx, ny] = true;
                            q.Enqueue(new Point(nx, ny));
                        }
                    }
                }
            }

            for (int y = 0; y < h; y++) {
                for (int x = 0; x < w; x++) {
                    Color c = src.GetPixel(x, y);
                    int diffRG = Math.Abs(c.R - c.G);
                    int diffGB = Math.Abs(c.G - c.B);
                    int diffRB = Math.Abs(c.R - c.B);
                    bool isNeutralChecker = (c.R >= 225 && diffRG <= 4 && diffGB <= 4 && diffRB <= 4);

                    if (visited[x, y] || isNeutralChecker) {
                        res.SetPixel(x, y, Color.FromArgb(0, 0, 0, 0));
                    } else {
                        res.SetPixel(x, y, c);
                    }
                }
            }

            res.Save(destPath, ImageFormat.Png);
            res.Dispose();
        }
    }
}
"@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies "System.Drawing"
$src = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202114363.png"
$dst = "c:\Users\ASUS\WHY-\assets\pappadam.png"
[ImageCleaner]::Process($src, $dst)
Write-Host "Processed cleanly!"
