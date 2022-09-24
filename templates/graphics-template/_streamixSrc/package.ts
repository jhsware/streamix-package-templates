import { createInterfaceClass, Utility } from 'component-registry';
import config from '../src/streamix_package.json';
import Component from '../src/Component';
import '../src/component.scss';

const Interface = createInterfaceClass('livemix');

const IEffectUtil = new Interface({
  name: 'IEffectUtil'
})

new Utility({
  implements: IEffectUtil,
  name: config.name,
  Component
});
