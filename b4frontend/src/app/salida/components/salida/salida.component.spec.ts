import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SalidaComponent } from './salida.component';

describe('SalidaComponent', () => {
  let component: SalidaComponent;
  let fixture: ComponentFixture<SalidaComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SalidaComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SalidaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
