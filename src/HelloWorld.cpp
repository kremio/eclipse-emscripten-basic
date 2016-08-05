#include <sstream>
#include <iostream>
#include <stdio.h>
#include <string>
#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

class Hello{

public:
	void open_video(char* video_url){
		open_video(video_url, true);
	}

	void open_video(char* video_url, bool autoplay){
		//A little bit of JavaScript
		std::ostringstream jScript;
		jScript << "var embedElem = document.createElement('div')\n";
		jScript << "embedElem.innerHTML = ";
		jScript << "'<iframe width=\"560\" height=\"315\" src=\"" << video_url << "?autoplay=" << (autoplay ? "1" : "0") << "\" frameborder=\"0\" allowfullscreen></iframe>'\n";
		jScript << "document.body.appendChild( embedElem )";
		std::cout << "Will run \n" << jScript.str() << "\n";
		emscripten_run_script(jScript.str().c_str());
	}

};

int main() {
  //And a little bit of C++, leaving together, in harmony
  Hello hello;
  hello.open_video( (char*)"https://www.youtube.com/embed/TZUV0CCD0ew" );
  return 0;
}
