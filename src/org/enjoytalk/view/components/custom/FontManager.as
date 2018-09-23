package org.enjoytalk.view.components.custom
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.Font;

	 
	import mx.events.Request;
	import mx.events.StyleEvent;
	import mx.rpc.events.FaultEvent;
	import mx.styles.IStyleManager2;

	public class FontManager
	{
		private var _sFontLibPath:String;
		private var _aSWFNames:Object;

		private var _onLoadProgress:Function;
		private var _onFontsLoaded:Function;
		private var _onFontsFail:Function;

		private var _aLangCodes:Array;
		private var _aFontNames:Array;
		private var _nLangIndex:Number=-1;

		private var _loadedFileCount:Number=0;

		private var fontLoader:FontLoader;

		private var _request:URLRequest;

		public static var _instance:FontManager;

		public static function getInstance():FontManager
		{
			if (_instance == null)
			{
				_instance=new FontManager();
			}
			return _instance;
		}


		public function FontManager(sFontLibPath:String=null)
		{
			if (sFontLibPath == null)
			{
				sFontLibPath=AppConstants.fontFolder;
			}
			_sFontLibPath=sFontLibPath;
			_aSWFNames=new Object();
			_aSWFNames[LanguageCodeManager.CODES.ENGLISH]="EN_Arial";
			_aSWFNames[LanguageCodeManager.CODES.JAPANESE]="JA_MSPGothic";
			_aSWFNames[LanguageCodeManager.CODES.KOREAN]="KO_Gulim";
			_aSWFNames[LanguageCodeManager.CODES.TAIWAN]="TW_ArialUnicodeMS";
			_aSWFNames[LanguageCodeManager.CODES.MANDARIN]="ZH_ArialUnicodeMS";
			_aSWFNames[LanguageCodeManager.CODES.IPA]="IPA_LucidaUnicodeMS";
		}


		public function loadFonts(aLangList:Array, callbackDone:Function, progressCallback:Function, callbackFail:Function):void
		{
			this._aFontNames=new Array();
			_onFontsLoaded=(callbackDone == null ? null : callbackDone);
			_onLoadProgress=(progressCallback == null ? null : progressCallback);
			_onFontsFail=(callbackFail == null ? null : callbackFail);
			_aLangCodes=new Array();
			for (var k:Number=0; k < aLangList.length; k++)
			{
				_aLangCodes[k]=aLangList[k].toLowerCase();
			}
			_nLangIndex=0;
			this.loadSWFFile("_lib.swf");
		}

		public function fontLibraryLoaded(event:Event):void
		{
			var oldLanCode:String=_aLangCodes[_nLangIndex];
			if (oldLanCode != null)
			{
				for (var k:Number=0; k < fontLoader.fonts.length; k++)
				{
					var font:Font=Font(fontLoader.fonts[k]);
					if (LanguageCodeManager.FONT_NAMES[oldLanCode] == null && font != null)
					{
						LanguageCodeManager.FONT_NAMES[oldLanCode]=font.fontName;
					}
				}
			}
			if (_nLangIndex++ < _aLangCodes.length)
			{
				var newLanCode:String=_aLangCodes[_nLangIndex];
				if (LanguageCodeManager.getInstance().isSupportEmbeddedFont(newLanCode))
				{
					this.loadSWFFile("_lib.swf");
					_loadedFileCount++;
				}
			}
			if (_onFontsLoaded != null)
			{
				_onFontsLoaded(event);
			}
		}

		public function onFontFail(event:IOErrorEvent):void
		{
			if (_onFontsFail != null)
			{
				_onFontsFail(event);
			}
		}

		public function onFontProgress(event:ProgressEvent):void
		{
			if (_onLoadProgress != null)
			{
				_onLoadProgress(event);
			}
		}


		public function loadSWFFile(sSuffix:String):void
		{
			var lanCode:String=_aLangCodes[_nLangIndex];
			if (lanCode == null)
			{
				return;
			}
			if (_aSWFNames[lanCode] == null)
			{
				this._onFontsFail();
				return;
			}
			fontLoader=new FontLoader();
			var requestUrl:String=_sFontLibPath + "/" + _aSWFNames[lanCode] + sSuffix;
			fontLoader.addEventListener(Event.COMPLETE, fontLibraryLoaded);
			fontLoader.addEventListener(IOErrorEvent.IO_ERROR, onFontFail);
			fontLoader.addEventListener(ProgressEvent.PROGRESS, onFontProgress);
			fontLoader.load(new URLRequest(requestUrl));
		}

	}
}
