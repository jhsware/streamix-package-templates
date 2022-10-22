import { createInterfaceClass, Utility } from 'component-registry';
import config from '../src/streamix_package.json';
import Component from '../src/Component';
import '../src/component.scss';

const Interface = createInterfaceClass('livemix');

const IStingerTransitionUtil = new Interface({
  name: 'IStingerTransitionUtil'
})

new Utility({
  implements: IStingerTransitionUtil,
  name: config.name,
  Component
});
