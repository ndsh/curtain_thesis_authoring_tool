class Farbe {
	color mDark;
	color mNormal;
	color mLight;
	color mWhite;
	Knob mColorKnob;
	int knobValue;
	CallbackListener cb;

	Farbe() {
		mDark = color(207, 100, 50);
		mNormal = color(207, 100, 64);
		mLight = color(207, 51, 77);
		mWhite = color(0, 0, 100);
		knobValue = 208;

	    cb = new CallbackListener() {
	        public void controlEvent(CallbackEvent theEvent) {
	           if (theEvent.getController().getName().equals("knobValue")) {
	            mDark = color(theEvent.getController().getValue(), 100, 50);
	            mNormal = color(theEvent.getController().getValue(), 100, 64);
	            mLight = color(theEvent.getController().getValue(), 51, 77);
	            ui.changeColor();
	          }
	        }
	    };

		 mColorKnob = cp5.addKnob("knobValue")
               .setRange(0,360)
               .setValue(knobValue)
               .setPosition(width-200,10)
               .setRadius(30)
               .setNumberOfTickMarks(20)
               .setCaptionLabel("color fun!")
               .setTickMarkLength(4)
               .snapToTickMarks(true)
               .setColorForeground(mLight)
               .setColorBackground(mDark)
               .setColorActive(mWhite)
               .setDragDirection(Knob.HORIZONTAL)
               .addCallback(cb)
               .setVisible(false)
               ;
	}
	color white() {
		return mWhite;
	}
	color dark() {
		return mDark;
	}
	color normal() {
		return mNormal;
	}
	color light() {
		return mLight;
	}

}